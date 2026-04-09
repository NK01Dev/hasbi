import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/states/auth_state.dart';

part 'session_provider.g.dart';

@riverpod
String? currentUserId(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState.maybeWhen(
    authenticated: (user) => user.id,
    orElse: () => null,
  );
}
