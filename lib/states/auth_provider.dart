import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _accessToken;

  bool get isLoggedIn => _isLoggedIn;
  String? get accessToken => _accessToken;

  AuthProvider() {
    _loadToken(); // 앱 시작 시 토큰을 불러옴
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    _isLoggedIn = _accessToken != null;
    notifyListeners();
  }

  Future<void> login(String token) async {
    _isLoggedIn = true;
    _accessToken = token;

    // SharedPreferences에 토큰 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _accessToken = null;

    // SharedPreferences에서 토큰 삭제
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    notifyListeners();
  }
}
