import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/storage/storage_service.dart';

class AuthNotifier extends ChangeNotifier {
  final StorageService _storageService;
  bool _isLoggedIn = false;
  Timer? _expiryTimer;

  bool get isLoggedIn => _isLoggedIn;

  AuthNotifier(this._storageService) {
    _checkAuthStatus();
    if (_isLoggedIn) {
      _startExpiryTimer();
    }
  }

  void _checkAuthStatus() {
    final token = _storageService.getToken();
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await _storageService.saveToken(token);
    _isLoggedIn = true;
    notifyListeners();
    _startExpiryTimer();
  }

  Future<void> logout() async {
    _expiryTimer?.cancel();
    await _storageService.clearAll();
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