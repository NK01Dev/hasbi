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
  final AppLogger _logger = AppLogger();

  AuthRepositoryImpl(this._account, this._databases);

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
  Future<User?> getCurrentAccount() async {
    try {
      return await _account.get();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    await _account.deleteSession(sessionId: 'current').catchError((_) {});
    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (_) {}

    await _hive.clearAuth();
  }

  @override
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  }) async {
    final account = await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: fullName,
    );

    await _account.createEmailPasswordSession(
      email: email,
      password: password,
    );

    final userProfile = UserModel(
      id: account.$id,
      email: email,
      fullName: fullName,
      age: age,
      gender: gender,
    );

    await createUserProfile(userProfile);
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    final data = user.toJson();
    data.removeWhere((key, value) => key.startsWith('\$'));

    await _databases.createDocument(
      databaseId: Environment.appwriteDatabaseId,
      collectionId: Environment.appwriteCollectionId,
      documentId: user.id,
      data: data,
    );

    await _hive.setUserData(data);
  }

  @override
  Future<UserModel?> getCurrentUserData(String userId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: Environment.appwriteDatabaseId,
        collectionId: Environment.appwriteCollectionId,
        documentId: userId,
      );
      return UserModel.fromJson(doc.data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    await _account.createOAuth2Session(
      provider: OAuthProvider.google,
    );
  }
}
@riverpod
AuthRepository authRepository(Ref ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabasesProvider);
  return AuthRepositoryImpl(account, databases);
}
