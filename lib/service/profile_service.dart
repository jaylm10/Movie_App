import 'package:shared_preferences/shared_preferences.dart';
class ProfileService {
  Future<void> storeProfile(String name,String mobile,String email,String bio)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    await pref.setString('name', name);
    await pref.setString('mobile', mobile);
    await pref.setString('email', email);
    await pref.setString('bio', bio);

  }

  Future<bool> checkProfileStatus()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.containsKey('name') &&
        pref.containsKey('mobile') &&
        pref.containsKey('email') &&
        pref.containsKey('bio');
  }

    Future<Map<String, String>> getProfile() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    return {
      'name': pref.getString('name') ?? '',
      'mobile': pref.getString('mobile') ?? '',
      'email': pref.getString('email') ?? '',
      'bio': pref.getString('bio') ?? '',
    };
  }

  Future<void> deleteAccount()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.clear();



  }




}