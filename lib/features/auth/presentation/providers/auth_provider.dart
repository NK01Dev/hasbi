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
    final repository = ref.read(authRepositoryProvider);

    try {
      final account = await repository.getCurrentAccount();

      if (account == null) {
        state = const AuthState.unauthenticated();
        return;
      }

      final userData =
      await repository.getCurrentUserData(account.$id);

      if (userData != null) {
        state = AuthState.authenticated(userData);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AuthState.loading();

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.loginWithEmail(
        email: email,
        password: password,
      );

      final account = await repository.getCurrentAccount();
      if (account == null) throw Exception("Login failed");

      // ONLY preference storage (not auth logic)
      await _hive.setRememberMe(rememberMe);

      if (rememberMe) {
        await _hive.setUserId(account.$id);
      } else {
        await _hive.clearAuth();
      }

      final userData =
      await repository.getCurrentUserData(account.$id);

      if (userData != null) {
        state = AuthState.authenticated(userData);
      } else {
        state = AuthState.needsProfileSetup(
          userId: account.$id,
          email: account.email,
        );
      }
    } catch (e, stack) {
      AppLogger().e("Login failed", e, stack);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  }) async {
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

      final account = await repository.getCurrentAccount();
      if (account == null) throw Exception("Registration failed");

      await _hive.setRememberMe(true);
      await _hive.setUserId(account.$id);

      final userData =
      await repository.getCurrentUserData(account.$id);

      if (userData != null) {
        state = AuthState.authenticated(userData);
      }
    } catch (e, stack) {
      AppLogger().e("Registration failed", e, stack);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.logout();

      state = const AuthState.unauthenticated();
    } catch (e, stack) {
      AppLogger().e("Logout failed", e, stack);
      state = AuthState.error(ErrorMapper.map(e));
    }
  }
}