
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> storeToken(String email)async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    await pref.setBool('isLoggedIn', true);
    await pref.setString('email', email);

  }

  Future<bool> checkStatus()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final bool? isLoggedIn = pref.getBool('isLoggedIn');
    return isLoggedIn ?? false;
  }

  Future<void> logout()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('isLoggedIn');

  }
}
