import 'package:hive_ce_flutter/hive_ce_flutter.dart'; // <--- The fixed import

class StorageService {
  static const String _boxName = 'authBox';
  static const String _tokenKey = 'token';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Future<void> saveToken(String token) async {
    var box = Hive.box(_boxName);
    await box.put(_tokenKey, token);
  }

  static String? getToken() {
    var box = Hive.box(_boxName);
    return box.get(_tokenKey);
  }

  static Future<void> clear() async {
    var box = Hive.box(_boxName);
    await box.clear();
  }
}