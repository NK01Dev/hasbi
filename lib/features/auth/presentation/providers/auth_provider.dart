import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../states/auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final HiveService _hive = HiveService();

  @override
  AuthState build() {
    _initAuth();
    return const AuthState.initial();
  }

  Future<void> _initAuth() async {
    // 1. Check Local Preference
    final rememberMe = _hive.rememberMe;
    final cachedUserId = _hive.userId;

    if (!rememberMe || cachedUserId == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    // 2. Check Server Session
    final repository = ref.read(authRepositoryProvider);
    final isLoggedIn = await repository.isUserLoggedIn();

    if (isLoggedIn) {
      final account = await repository.getCurrentAccount();
      if (account != null) {
        // Try fetching from Hive Cache first for speed (UX Enhancement)
        final cachedData = _hive.getUserData();
        if (cachedData != null) {
          state = AuthState.authenticated(UserModel.fromJson(cachedData));
        } else {
          // Fallback to DB
          final userData = await repository.getCurrentUserData(account.$id);
          if (userData != null) {
            state = AuthState.authenticated(userData);
          } else {
            state = const AuthState.unauthenticated();
          }
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async
  {
    state = const AuthState.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.loginWithEmail(email: email, password: password);

      final account = await repository.getCurrentAccount();
      if (account == null) throw Exception("Account fetch failed");

      // Save Preference
      await _hive.setRememberMe(rememberMe);
      await _hive.setUserId(account.$id);
      await _hive.setIsLoggedIn(true); // Save login state

      final userData = await repository.getCurrentUserData(account.$id);
      if (userData != null) {
        state = AuthState.authenticated(userData);
      } else {
        state = AuthState.needsProfileSetup(
          userId: account.$id,
          email: account.email,
        );
      }
    } catch (e, stackTrace) {
      AppLogger().e("Login sequence failed", e, stackTrace);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  }) async
  {
    state = const AuthState.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.registerWithEmail(
        email: email,
        password: password,
        fullName: fullName,
        age: age,
        gender: gender,
      );

      // Auto-login implies remember me
      final account = await repository.getCurrentAccount();
      if (account != null) {
        await _hive.setRememberMe(true);
        await _hive.setUserId(account.$id);
        await _hive.setIsLoggedIn(true); // Save login state

        final userData = await repository.getCurrentUserData(account.$id);
        if (userData != null) {
          state = AuthState.authenticated(userData);
        }
      }
    } catch (e, stackTrace) {
      AppLogger().e("Registration sequence failed", e, stackTrace);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e, stackTrace) {
      AppLogger().e("Logout failed", e, stackTrace);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }
}