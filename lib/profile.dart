import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/profile/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/login.dart';
import 'package:movie/fav_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  bool isEditing = false;

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

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileCompleted) {
          nameController.text = state.name.isNotEmpty
              ? state.name
              : nameController.text;
          mobileController.text = state.mobile.isNotEmpty
              ? state.mobile
              : mobileController.text;
          emailController.text =
              state.email.isNotEmpty ? state.email : emailController.text;
          bioController.text = state.bio.isNotEmpty ? state.bio : bioController.text;

          if (isEditing) {
            setState(() {
              isEditing = false;
            });
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),
                buildField("Name", nameController),
                buildField("Mobile", mobileController),
                buildField("Email", emailController),
                buildField("Bio", bioController),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavPage(),
                        ),
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
                    onPressed: deleteAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Delete Account"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}