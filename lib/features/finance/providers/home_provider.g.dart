// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeNotifier)
final homeProvider = HomeNotifierProvider._();

final class HomeNotifierProvider
    extends $NotifierProvider<HomeNotifier, FinanceState> {
  HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanceState>(value),
    );
  }
}

String _$homeNotifierHash() => r'dcef80c23e87c595f57fe0a11df71e2ae5668dab';

abstract class _$HomeNotifier extends $Notifier<FinanceState> {
  FinanceState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FinanceState, FinanceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FinanceState, FinanceState>,
              FinanceState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
