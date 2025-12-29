import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Ma'lumotlarni saqlash
  Future<void> saveCredentials(
    String username,
    String password,
    bool rememberMe,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  // Ma'lumotlarni yuklash
  Future<Map<String, dynamic>> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'username': prefs.getString('username') ?? '',
      'password': prefs.getString('password') ?? '',
      'rememberMe': prefs.getBool('rememberMe') ?? false,
    };
  }

  // Ma'lumotlarni o'chirish
  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.setBool('rememberMe', false);
  }

  // SharedPreferences instance olish
  Future<SharedPreferences> getPrefs() async {
    return await SharedPreferences.getInstance();
  }
}
