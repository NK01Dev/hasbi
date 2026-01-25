import 'package:hive_flutter/hive_flutter.dart';

class HiveKeys {
  static const String rememberMe = 'remember_me';
  static const String userId = 'user_id';
  static const String userData = 'user_data';
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String isLoggedIn = 'is_logged_in';
}

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox('authBox');
  }

  // Remember Me
  bool get rememberMe => _box.get(HiveKeys.rememberMe, defaultValue: false);
  Future<void> setRememberMe(bool value) => _box.put(HiveKeys.rememberMe, value);
  
  // --- Onboarding ---
  bool get hasSeenOnboarding => _box.get(HiveKeys.hasSeenOnboarding, defaultValue: false);
  Future<void> setHasSeenOnboarding(bool value) => _box.put(HiveKeys.hasSeenOnboarding, value);

  // --- Login State (NEW) ---
  bool get isLoggedIn => _box.get(HiveKeys.isLoggedIn, defaultValue: false);
  Future<void> setIsLoggedIn(bool value) => _box.put(HiveKeys.isLoggedIn, value);

  // User ID / Data
  String? get userId => _box.get(HiveKeys.userId);
  Future<void> setUserId(String? id) => _box.put(HiveKeys.userId, id);

  dynamic getUserData() => _box.get(HiveKeys.userData);
  Future<void> setUserData(dynamic data) => _box.put(HiveKeys.userData, data);

  Future<void> clearAuth() async {
    await _box.delete(HiveKeys.userId);
    await _box.delete(HiveKeys.userData);
    await _box.delete(HiveKeys.isLoggedIn);
    // Reset onboarding flag so user sees onboarding again after logout
    await _box.delete(HiveKeys.hasSeenOnboarding);
    // We keep "rememberMe" preference checked or not as per user choice
  }
}