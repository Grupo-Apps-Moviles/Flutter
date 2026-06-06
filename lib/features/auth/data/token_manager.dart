import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  final SharedPreferences _prefs;

  TokenManager(this._prefs);

  // TOKEN
  Future<void> saveToken(String token) async {
    await _prefs.setString('jwt', token);
  }

  String? getToken() {
    return _prefs.getString('jwt');
  }

  // USER ID
  Future<void> saveUserId(int userId) async {
    await _prefs.setInt('user_id', userId);
  }

  int? getUserId() {
    return _prefs.getInt('user_id');
  }

  // ROLE
  Future<void> saveRole(int role) async {
    await _prefs.setInt('role', role);
  }

  int? getRole() {
    return _prefs.getInt('role');
  }

  // USERNAME
  Future<void> saveUsername(String username) async {
    await _prefs.setString('username', username);
  }

  String? getUsername() {
    return _prefs.getString('username');
  }

  // EMAIL
  Future<void> saveEmail(String email) async {
    await _prefs.setString('email', email);
  }

  String? getEmail() {
    return _prefs.getString('email');
  }

  // LOGOUT
  Future<void> clearSession() async {
    await _prefs.clear();
  }
}