
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> storeToken()async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    
    await pref.setBool('isLoggedIn', true);

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
