import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/user_model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.authenticated(UserModel user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.needsProfileSetup({
    required String userId,
    required String email,
  }) = AuthStateNeedsProfileSetup;
  const factory AuthState.error(String message) = AuthStateError;
}