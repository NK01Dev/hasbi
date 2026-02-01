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

String _$selectedDateHash() => r'587eebf9e6a68e26118fe99ebcf13d6a94f2ff77';

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

String _$customRangeHash() => r'568bd13dba162f8bcd377c93784d3dc80df94c6a';

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

@ProviderFor(StatisticsController)
final statisticsControllerProvider = StatisticsControllerProvider._();

final class StatisticsControllerProvider
    extends $NotifierProvider<StatisticsController, StatsPeriod> {
  StatisticsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statisticsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statisticsControllerHash();

  @$internal
  @override
  StatisticsController create() => StatisticsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsPeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsPeriod>(value),
    );
  }
}

String _$statisticsControllerHash() =>
    r'597afcd7865f4613a7106314440234e796b5e828';

abstract class _$StatisticsController extends $Notifier<StatsPeriod> {
  StatsPeriod build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StatsPeriod, StatsPeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatsPeriod, StatsPeriod>,
              StatsPeriod,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(StatisticsNotifier)
final statisticsProvider = StatisticsNotifierFamily._();

final class StatisticsNotifierProvider
    extends $AsyncNotifierProvider<StatisticsNotifier, StatisticsData> {
  StatisticsNotifierProvider._({
    required StatisticsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'statisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statisticsNotifierHash();

  @override
  String toString() {
    return r'statisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StatisticsNotifier create() => StatisticsNotifier();

  @override
  bool operator ==(Object other) {
    return other is StatisticsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statisticsNotifierHash() =>
    r'11524520ccf101224b4945b4f2e2b245af103914';

final class StatisticsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          StatisticsNotifier,
          AsyncValue<StatisticsData>,
          StatisticsData,
          FutureOr<StatisticsData>,
          String
        > {
  StatisticsNotifierFamily._()
    : super(
        retry: null,
        name: r'statisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StatisticsNotifierProvider call(String userId) =>
      StatisticsNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'statisticsProvider';
}

abstract class _$StatisticsNotifier extends $AsyncNotifier<StatisticsData> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<StatisticsData> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StatisticsData>, StatisticsData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StatisticsData>, StatisticsData>,
              AsyncValue<StatisticsData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(PieChartNotifier)
final pieChartProvider = PieChartNotifierFamily._();

final class PieChartNotifierProvider
    extends $AsyncNotifierProvider<PieChartNotifier, List<CategoryStat>> {
  PieChartNotifierProvider._({
    required PieChartNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pieChartProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pieChartNotifierHash();

  @override
  String toString() {
    return r'pieChartProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PieChartNotifier create() => PieChartNotifier();

  @override
  bool operator ==(Object other) {
    return other is PieChartNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pieChartNotifierHash() => r'2d93937ca4c638818c18e92021b7dbe187b2d199';

final class PieChartNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PieChartNotifier,
          AsyncValue<List<CategoryStat>>,
          List<CategoryStat>,
          FutureOr<List<CategoryStat>>,
          String
        > {
  PieChartNotifierFamily._()
    : super(
        retry: null,
        name: r'pieChartProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PieChartNotifierProvider call(String userId) =>
      PieChartNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'pieChartProvider';
}

abstract class _$PieChartNotifier extends $AsyncNotifier<List<CategoryStat>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<CategoryStat>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CategoryStat>>, List<CategoryStat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CategoryStat>>, List<CategoryStat>>,
              AsyncValue<List<CategoryStat>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
