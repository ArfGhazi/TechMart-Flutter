import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  late SharedPreferences _prefs;

  final RxBool isLoggedIn = false.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();

    isLoggedIn.value = _prefs.getBool(_isLoggedInKey) ?? false;
    userName.value = _prefs.getString(_userNameKey) ?? '';
    userEmail.value = _prefs.getString(_userEmailKey) ?? '';

    return this;
  }

  Future<void> login({required String name, required String email}) async {
    await _prefs.setBool(_isLoggedInKey, true);
    await _prefs.setString(_userNameKey, name);
    await _prefs.setString(_userEmailKey, email);

    isLoggedIn.value = true;
    userName.value = name;
    userEmail.value = email;
  }

  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);

    isLoggedIn.value = false;
    userName.value = '';
    userEmail.value = '';
  }
}
