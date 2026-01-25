// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_nav_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NavIndex)
final navIndexProvider = NavIndexProvider._();

final class NavIndexProvider extends $NotifierProvider<NavIndex, int> {
  NavIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navIndexHash();

  @$internal
  @override
  NavIndex create() => NavIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$navIndexHash() => r'c88fbb3ae53e2404f1659c43c4b184f2ced60030';

abstract class _$NavIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
