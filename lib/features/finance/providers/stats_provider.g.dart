// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatsFilter)
final statsFilterProvider = StatsFilterProvider._();

final class StatsFilterProvider
    extends $NotifierProvider<StatsFilter, DateFilterMode> {
  StatsFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsFilterHash();

  @$internal
  @override
  StatsFilter create() => StatsFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateFilterMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateFilterMode>(value),
    );
  }
}

String _$statsFilterHash() => r'37b0694b1718e507743ce5c9b0c8f4deac8acc2e';

abstract class _$StatsFilter extends $Notifier<DateFilterMode> {
  DateFilterMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateFilterMode, DateFilterMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateFilterMode, DateFilterMode>,
              DateFilterMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(StatsNotifier)
final statsProvider = StatsNotifierProvider._();

final class StatsNotifierProvider
    extends
        $AsyncNotifierProvider<StatsNotifier, List<TransactionDisplayModel>> {
  StatsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsNotifierHash();

  @$internal
  @override
  StatsNotifier create() => StatsNotifier();
}

String _$statsNotifierHash() => r'e2ffbcb7a777f7f93abfc46b00db9b30fff587a8';

abstract class _$StatsNotifier
    extends $AsyncNotifier<List<TransactionDisplayModel>> {
  FutureOr<List<TransactionDisplayModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<TransactionDisplayModel>>,
              List<TransactionDisplayModel>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<TransactionDisplayModel>>,
                List<TransactionDisplayModel>
              >,
              AsyncValue<List<TransactionDisplayModel>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedDate)
final selectedDateProvider = SelectedDateProvider._();

final class SelectedDateProvider
    extends $NotifierProvider<SelectedDate, DateTime> {
  SelectedDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDateHash();

  @$internal
  @override
  SelectedDate create() => SelectedDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$selectedDateHash() => r'17f202c5ca10d40f37a0d7b07572ed0998bf6a7f';

abstract class _$SelectedDate extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CustomRange)
final customRangeProvider = CustomRangeProvider._();

final class CustomRangeProvider
    extends $NotifierProvider<CustomRange, DateTimeRange<DateTime>?> {
  CustomRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customRangeHash();

  @$internal
  @override
  CustomRange create() => CustomRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>?>(value),
    );
  }
}

String _$customRangeHash() => r'abb219972620ed07adac8ca0caf80fabf5f3f836';

abstract class _$CustomRange extends $Notifier<DateTimeRange<DateTime>?> {
  DateTimeRange<DateTime>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTimeRange<DateTime>?, DateTimeRange<DateTime>?>,
              DateTimeRange<DateTime>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
