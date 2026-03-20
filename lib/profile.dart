import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/auth_gate.dart';
import 'package:movie/bloc/auth/auth_bloc.dart';
import 'package:movie/bloc/profile/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/fav_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  bool isEditing = false;



  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadData();
    context.read<ProfileBloc>().add(CheckProfileStatusEvent());
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    nameController.text = prefs.getString('name') ?? '';
    mobileController.text = prefs.getString('mobile') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    bioController.text = prefs.getString('bio') ?? '';
  }

  void saveData() {
    context.read<ProfileBloc>().add(
      SubmitProfileEvent(
        name: nameController.text,
        mobile: mobileController.text,
        email: emailController.text,
        bio: bioController.text,
      ),
    );
  }

  Future<void> deleteAccount() async {
    context.read<ProfileBloc>().add(DeleteAccountEvent());
    context.read<AuthBloc>().add(LogoutEvent());

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

  // Widget buildField(String label, TextEditingController controller) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     child: TextField(
  //       controller: controller,
  //       enabled: isEditing,
  //       decoration: InputDecoration(
  //         labelText: label,
  //         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileCompleted) {
            nameController.text = state.name.isNotEmpty
                ? state.name
                : nameController.text;
            mobileController.text = state.mobile.isNotEmpty
                ? state.mobile
                : mobileController.text;
            emailController.text = state.email.isNotEmpty
                ? state.email
                : emailController.text;
            bioController.text = state.bio.isNotEmpty
                ? state.bio
                : bioController.text;
      
            if (isEditing) {
              setState(() {
                isEditing = false;
              });
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
      
                  TextField(
                    controller: nameController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
      
                  TextField(
                    keyboardType: TextInputType.phone,
                    controller: mobileController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: "Mobile",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: bioController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
      
                  // buildField("Name", nameController),
                  // buildField("Mobile", mobileController),
                  // buildField("Email", emailController),
                  // buildField("Bio", bioController),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isEditing) {
                          saveData();
                        } else {
                          setState(() {
                            isEditing = true;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(isEditing ? "Save" : "Edit"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FavPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                      ),
                      child: const Text("Favorites"),
                    ),
                  ),
                  const SizedBox(height: 10),

                   SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                          
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const AuthGate()),
                          (route) => false,
                        );
                      },
                      child: const Text('Log out'),
                    ),
                  ),

                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Account"),
                            content: const Text(
                              "Are you sure you want to delete your account? This action cannot be undone.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
      
                        if (confirm == true) {      
                          deleteAccount();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text("Delete Account"),
                    ),
                  ),

                  const SizedBox(height: 10,),
      
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
