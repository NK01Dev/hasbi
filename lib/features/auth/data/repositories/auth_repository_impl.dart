import 'package:appwrite/appwrite.dart';
import 'package:logging/logging.dart';
import 'package:appwrite/enums.dart'; // ignore: unused_import
import 'package:appwrite/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/appwrite_config.dart';
import '../../../../core/config/environment.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Account _account;
  final Databases _databases;
  final HiveService _hive = HiveService();
  final AppLogger _logger = AppLogger(); // Singleton

  final _log = Logger('AuthRepository');

  AuthRepositoryImpl(this._account, this._databases);

  @override
  Future<void> signInWithGoogle() async {
    _log.info('Initiating Google Sign-In');
    await _account.createOAuth2Session(provider: OAuthProvider.google);
  }

  @override
  Future<User?> getCurrentAccount() async {
    try {
      final user = await _account.get();
      _log.info('Retrieved current account: ${user.$id}');
      return user;
    } catch (e) {
      _log.warning('Failed to get current account', e);
      return null;
    }
  }

  @override
  Future<UserModel?> getCurrentUserData(String userId) async {
    try {
      _log.info('Fetching user data for: $userId');
      final doc = await _databases.getDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.appwriteCollectionId,
        documentId: userId,
      );
      return UserModel.fromJson(doc.data);
    } catch (e) {
      _log.severe('Failed to fetch user data for $userId', e);

      return null;
    }
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    _log.info('Creating user profile for: ${user.id}');
    try {
      // CLEAN DATA: Remove system fields (\$) before sending to Appwrite
      final data = user.toJson();
      data.removeWhere((key, value) => key.startsWith('\$'));

      await _databases.createDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.appwriteCollectionId,
        documentId: user.id,
        data: data,
      );
      // Cache user data locally for instant load
      await _hive.setUserData(data);
    } on AppwriteException catch (e) {
      _log.severe(
        'Appwrite error in createUserProfile: ${e.code} - ${e.message} (${e.type})',
      );
      rethrow;
    } catch (e) {
      _log.severe('Unexpected error in createUserProfile', e);
      rethrow;
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      await _account.get();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _log.info('Logging out user');
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        _log.info('Session already invalid or expired (401)');
      } else {
        _log.severe('Appwrite error during logout: ${e.code} - ${e.message}');
        rethrow;
      }
    } catch (e) {
      _log.severe('Unexpected error during logout', e);
      rethrow;
    } finally {
      await _hive.clearAuth();
    }
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  }) async {
    try {
      // 1. Create the Auth Account
      // Expert Tip: Pass 'name' so the Appwrite Console displays the full name
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: "$fullName ",
      );

      // 2. Create Session immediately
      // We do this before writing to DB to ensure the user has permissions
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (e) {
        _logger.d(
          "Cleanup: No session to delete before registration auto-login.",
        );
      }

      _logger.i("Creating auto-login session for registered user: $email");
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      _logger.i("Registration session created successfully");

      // 3. Prepare the Model
      final userProfile = UserModel(
        id: account.$id,
        email: email,
        fullName: fullName,
        age: age,
        gender: gender,
      );

      // 4. Create Profile in Database
      await createUserProfile(userProfile);
    } catch (e) {
      // Optional: Cleanup logic could go here.
      _log.info('registerWithEmail in user: $e');

      // If step 4 fails, the user exists in Auth but not DB.
      // You might want to call _account.delete(userId: account.$id) here
      // to allow the user to retry registration without errors.
      rethrow; // Re-throw the error for the UI to handle
    }
  }

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _log.info('Logging in user: $email');
    try {
      // CLEAR existing session if any to avoid 'user_session_already_exists'
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (_) {
      // Ignore if no session exists
      _logger.d("Cleanup: No active session to delete before login.");
    } catch (e) {
      _logger.e("Unexpected error during session cleanup", e);
    }

    _logger.i("Attempting login for: $email");
    await _account.createEmailPasswordSession(email: email, password: password);
    _logger.i("Login session created successfully");
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabasesProvider);
  return AuthRepositoryImpl(account, databases);
}
