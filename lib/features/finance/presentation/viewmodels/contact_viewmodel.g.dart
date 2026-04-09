// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ContactViewModel)
final contactViewModelProvider = ContactViewModelProvider._();

final class ContactViewModelProvider
    extends $NotifierProvider<ContactViewModel, ContactState> {
  ContactViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactViewModelHash();

  @$internal
  @override
  ContactViewModel create() => ContactViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactState>(value),
    );
  }
}

String _$contactViewModelHash() => r'f9bca75b6e24ec63cc5e4004859cb01a0982111a';

abstract class _$ContactViewModel extends $Notifier<ContactState> {
  ContactState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ContactState, ContactState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactState, ContactState>,
              ContactState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
