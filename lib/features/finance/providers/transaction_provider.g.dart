// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionFilter)
final transactionFilterProvider = TransactionFilterProvider._();

final class TransactionFilterProvider
    extends $NotifierProvider<TransactionFilter, DateFilterMode> {
  TransactionFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFilterHash();

  @$internal
  @override
  TransactionFilter create() => TransactionFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateFilterMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateFilterMode>(value),
    );
  }
}

String _$transactionFilterHash() => r'768c389bf05cd709ed4ac8f72b76b09219f86420';

abstract class _$TransactionFilter extends $Notifier<DateFilterMode> {
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

@ProviderFor(TransactionDate)
final transactionDateProvider = TransactionDateProvider._();

final class TransactionDateProvider
    extends $NotifierProvider<TransactionDate, DateTime> {
  TransactionDateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionDateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionDateHash();

  @$internal
  @override
  TransactionDate create() => TransactionDate();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$transactionDateHash() => r'066e794293bc4a4a5aae822b26f43c1532ae1179';

abstract class _$TransactionDate extends $Notifier<DateTime> {
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

@ProviderFor(TransactionRange)
final transactionRangeProvider = TransactionRangeProvider._();

final class TransactionRangeProvider
    extends $NotifierProvider<TransactionRange, DateTimeRange<DateTime>?> {
  TransactionRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRangeHash();

  @$internal
  @override
  TransactionRange create() => TransactionRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTimeRange<DateTime>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTimeRange<DateTime>?>(value),
    );
  }
}

String _$transactionRangeHash() => r'0630e968e32a4ab59c5f6f0d9c33064b1aae62b6';

abstract class _$TransactionRange extends $Notifier<DateTimeRange<DateTime>?> {
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

@ProviderFor(Transactions)
final transactionsProvider = TransactionsProvider._();

final class TransactionsProvider
    extends
        $AsyncNotifierProvider<Transactions, List<TransactionDisplayModel>> {
  TransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @$internal
  @override
  Transactions create() => Transactions();
}

String _$transactionsHash() => r'4f10495897d3de1df51349c83caa048f70bcb6d3';

abstract class _$Transactions
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
