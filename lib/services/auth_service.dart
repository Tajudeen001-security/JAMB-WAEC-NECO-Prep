import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _accountKey = 'jwnp_account';
  static const _sessionKey = 'jwnp_session';

  String _hash(String value) =>
      sha256.convert(utf8.encode(value)).toString();

  Future<bool> signUp({
    required String name,
    required String identifier,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (identifier.trim().isEmpty || password.length < 6 || name.trim().isEmpty) {
      return false;
    }
    if (prefs.containsKey(_accountKey)) return false;
    await prefs.setString(_accountKey, jsonEncode({
      'name': name.trim(),
      'identifier': identifier.trim().toLowerCase(),
      'password': _hash(password),
    }));
    await prefs.setBool(_sessionKey, true);
    return true;
  }

  Future<bool> login(String identifier, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountKey);
    if (raw == null) return false;
    final account = jsonDecode(raw) as Map<String, dynamic>;
    final ok = account['identifier'] == identifier.trim().toLowerCase() &&
        account['password'] == _hash(password);
    if (ok) await prefs.setBool(_sessionKey, true);
    return ok;
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }

  Future<String?> currentName() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountKey);
    if (raw == null) return null;
    return (jsonDecode(raw) as Map<String, dynamic>)['name'] as String?;
  }

  Future<String?> currentIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_accountKey);
    if (raw == null) return null;
    return (jsonDecode(raw) as Map<String, dynamic>)['identifier'] as String?;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionKey, false);
  }
}
