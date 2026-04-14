import 'package:hive_flutter/hive_flutter.dart';

class HiveKeys {
  static const String rememberMe = 'remember_me';
  static const String userId = 'user_id';
  static const String userData = 'user_data';
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String financeCache = 'finance_cache';
  static const String financeCacheTs = 'finance_cache_ts'; // timestamp
}

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox('authBox');
  }

  // =====================
  // Remember Me (UX ONLY)
  // =====================
  bool get rememberMe => _box.get(HiveKeys.rememberMe, defaultValue: false);

  Future<void> setRememberMe(bool value) =>
      _box.put(HiveKeys.rememberMe, value);

  // =====================
  // Onboarding
  // =====================
  bool get hasSeenOnboarding =>
      _box.get(HiveKeys.hasSeenOnboarding, defaultValue: false);

  Future<void> setHasSeenOnboarding(bool value) =>
      _box.put(HiveKeys.hasSeenOnboarding, value);

  // =====================
  // Cached User ID (optional UX speed boost)
  // =====================
  String? get userId => _box.get(HiveKeys.userId);

  Future<void> setUserId(String? id) async {
    if (id == null) {
      await _box.delete(HiveKeys.userId);
    } else {
      await _box.put(HiveKeys.userId, id);
    }
  }

  // =====================
  // Cached User Data (offline/fast load)
  // =====================
  dynamic getUserData() => _box.get(HiveKeys.userData);

  Future<void> setUserData(dynamic data) => _box.put(HiveKeys.userData, data);

  // =====================
  // AUTH CLEANUP
  // =====================
  Future<void> clearAuth() async {
    await _box.delete(HiveKeys.userId);
    await _box.delete(HiveKeys.userData);
    await _box.delete(HiveKeys.hasSeenOnboarding);

    // ❗ we intentionally DO NOT clear rememberMe
    // because it's a user preference, not auth state
  }

  // =====================
  // Finance Cache
  // =====================
  Map<String, dynamic>? getFinanceCache() {
    final raw = _box.get(HiveKeys.financeCache);
    if (raw == null) return null;
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<void> setFinanceCache(Map<String, dynamic> data) async {
    await _box.put(HiveKeys.financeCache, data);
    await _box.put(
      HiveKeys.financeCacheTs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  bool get isFinanceCacheStale {
    final ts = _box.get(HiveKeys.financeCacheTs) as int?;
    if (ts == null) return true;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    return age > const Duration(hours: 1).inMilliseconds;
  }
}
