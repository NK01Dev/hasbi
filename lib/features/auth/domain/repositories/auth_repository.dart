import 'package:appwrite/models.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  /// Sign in using Google OAuth2
  Future<void> signInWithGoogle();

  /// Get currently logged in user metadata from Appwrite Database
  Future<UserModel?> getCurrentUserData(String userId);

  /// Create a new user profile in the database after registration
  Future<void> createUserProfile(UserModel user);

  /// Check if a session exists
  Future<bool> isUserLoggedIn();

  /// Log out the user
  Future<void> logout();

  /// Get current Appwrite account (NEW METHOD)
  Future<User?> getCurrentAccount();

  /// Register with email and password (NEW METHOD)
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String fullName,
    required int age,
    required String gender,
  });

  /// Login with email and password (NEW METHOD)
  Future<void> loginWithEmail({
    required String email,
    required String password,
  });
}