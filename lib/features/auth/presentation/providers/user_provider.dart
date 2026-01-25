import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:appwrite/models.dart' as appwrite;
import '../../../../core/utils/app_logger.dart';
import '../providers/auth_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/models/user_model.dart';

part 'user_provider.g.dart';

@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<UserModel?> build() async {
    final authRepo = ref.watch(authRepositoryProvider);

    try {
      // 1. Check Auth Session
      final account = await authRepo.getCurrentAccount();

      if (account == null) {
        AppLogger().i('No active session found.');
        return null;
      }

      // 2. Fetch Profile Data from Database
      // The Auth ID matches the Document ID in Appwrite
      final userProfile = await authRepo.getCurrentUserData(account.$id);

      if (userProfile != null) {
        AppLogger().i('User profile loaded: ${userProfile.fullName}');
        return userProfile;
      } else {
        // Fallback: If profile exists in auth but not DB (edge case), return null or handle error
        AppLogger().w('Auth user found, but no database profile document.');
        return null;
      }
    } catch (e, stack) {
      AppLogger().e('Error loading user profile', e, stack);
      return null;
    }
  }

  /// Refreshes the user data manually
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}