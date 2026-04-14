import 'package:appwrite/models.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> signInWithGoogle();
  Future<User?> getCurrentAccount();
  Future<UserModel?> getCurrentUserData(String userId);

  Future<void> createUserProfile(UserModel user);

  Future<bool> isUserLoggedIn();

  Future<void> logout();

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  });

  Future<void> loginWithEmail({
    required String email,
    required String password,
  });
}