import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/storage/storage_service.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;
  Timer? _expiryTimer;

  bool get isLoggedIn => _isLoggedIn;

  AuthNotifier() {
    _checkAuthStatus();
    if (_isLoggedIn) {
      _startExpiryTimer();
    }
  }

  void _checkAuthStatus() {
    final token = StorageService.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await StorageService.saveToken(token);
    _isLoggedIn = true;
    notifyListeners();
    _startExpiryTimer();
  }

  void logout() {
    _expiryTimer?.cancel();
    StorageService.clear();
    _isLoggedIn = false;
    notifyListeners();
  }

  void _startExpiryTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = Timer(const Duration(seconds: 1200), () {
      logout();
    });
  }

  @override
  void dispose() {
    _expiryTimer?.cancel();
    super.dispose();
  }
}