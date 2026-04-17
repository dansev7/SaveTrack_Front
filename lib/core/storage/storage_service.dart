import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'hive_adapters.dart';

class StorageService {
  static const String _authBoxName = 'auth_box';
  static const String _cacheBoxName = 'cache_box';
  static const String _tokenKey = 'token';
  static const String _dashboardCacheKey = 'dashboard_cache';
  static const String _goalsCacheKey = 'goals_cache';
  static const String _transactionsCacheKey = 'transactions_cache';
  late Box _authBox;
  late Box _cacheBox;

  // Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();
    
    // Register all generated adapters
    HiveAdapters.register();
    
    _authBox = await Hive.openBox(_authBoxName);
    _cacheBox = await Hive.openBox(_cacheBoxName);
  }

  // --- Auth Methods ---
  
  Future<void> saveToken(String token) async {
    await _authBox.put(_tokenKey, token);
  }

  String? getToken() {
    return _authBox.get(_tokenKey);
  }

  Future<void> clearToken() async {
    await _authBox.delete(_tokenKey);
  }

  // --- Generic Cache Methods ---

  Future<void> save<T>(String key, T value) async {
    await _cacheBox.put(key, value);
  }

  T? get<T>(String key) {
    return _cacheBox.get(key) as T?;
  }

  // --- Specific Dashboard Cache Methods ---

  Future<void> saveDashboardCache(dynamic data) async {
    await _cacheBox.put(_dashboardCacheKey, data);
  }

  dynamic getDashboardCache() {
    return _cacheBox.get(_dashboardCacheKey);
  }

  // --- Specific Goals Cache Methods ---

  Future<void> saveGoalsCache(dynamic data) async {
    await _cacheBox.put(_goalsCacheKey, data);
  }

  dynamic getGoalsCache() {
    return _cacheBox.get(_goalsCacheKey);
  }

  

  Future<void> clearAll() async {
    await _authBox.clear();
    await _cacheBox.clear();
  }
}