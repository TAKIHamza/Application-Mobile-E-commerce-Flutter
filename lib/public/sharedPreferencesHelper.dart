import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferencesHelper? _instance;
  SharedPreferences? _prefs;

  factory SharedPreferencesHelper() {
    _instance ??= SharedPreferencesHelper._();
    return _instance!;
  }

  SharedPreferencesHelper._();

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token, String user) async {
    await _prefs?.setString('token', token);
    await _prefs?.setString('user', user);
  }

  String? getToken() {
    return _prefs?.getString('token');
  }
  
  String? getUser() {
    return _prefs?.getString('user');
  }

  Future<void> clearData() async {
    await _prefs?.clear();
  }
}
