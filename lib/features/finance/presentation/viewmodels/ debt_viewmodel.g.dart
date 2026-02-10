// GENERATED CODE - DO NOT MODIFY BY HAND

part of ' debt_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DebtViewModel)
final debtViewModelProvider = DebtViewModelProvider._();

final class DebtViewModelProvider
    extends $NotifierProvider<DebtViewModel, DebtState> {
  DebtViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtViewModelHash();

  @$internal
  @override
  DebtViewModel create() => DebtViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DebtState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DebtState>(value),
    );
  }
}

String _$debtViewModelHash() => r'f66c8e3ff19d36aa7a92c18c76c7385261087910';

abstract class _$DebtViewModel extends $Notifier<DebtState> {
  DebtState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DebtState, DebtState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DebtState, DebtState>,
              DebtState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
