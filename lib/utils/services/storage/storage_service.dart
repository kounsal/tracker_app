import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@LazySingleton()
class StorageService {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyIsLoggedIn = 'is_logged_in';

  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  StorageService(this._prefs);

  // Access Token
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _keyAccessToken);
  }

  Future<void> removeAccessToken() async {
    await _secureStorage.delete(key: _keyAccessToken);
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  Future<void> removeUserId() async {
    await _prefs.remove(_keyUserId);
  }

  // Login State
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool(_keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _secureStorage.delete(key: _keyAccessToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyIsLoggedIn);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs.clear();
  }
}
