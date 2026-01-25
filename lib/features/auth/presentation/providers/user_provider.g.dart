// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $AsyncNotifierProvider<CurrentUser, UserModel?> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();
}

String _$currentUserHash() => r'863b4e85a7f5e52aa3c15db151852b2407b9a5bf';

abstract class _$CurrentUser extends $AsyncNotifier<UserModel?> {
  FutureOr<UserModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserModel?>, UserModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserModel?>, UserModel?>,
              AsyncValue<UserModel?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
