// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(financeDatabases)
final financeDatabasesProvider = FinanceDatabasesProvider._();

final class FinanceDatabasesProvider
    extends $FunctionalProvider<Databases, Databases, Databases>
    with $Provider<Databases> {
  FinanceDatabasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeDatabasesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeDatabasesHash();

  @$internal
  @override
  $ProviderElement<Databases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Databases create(Ref ref) {
    return financeDatabases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Databases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Databases>(value),
    );
  }
}

String _$financeDatabasesHash() => r'ecd9d8dd1839338a00dbae83b56315c17f932850';

@ProviderFor(financeApiService)
final financeApiServiceProvider = FinanceApiServiceProvider._();

final class FinanceApiServiceProvider
    extends
        $FunctionalProvider<
          FinanceApiService,
          FinanceApiService,
          FinanceApiService
        >
    with $Provider<FinanceApiService> {
  FinanceApiServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeApiServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeApiServiceHash();

  @$internal
  @override
  $ProviderElement<FinanceApiService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinanceApiService create(Ref ref) {
    return financeApiService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanceApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanceApiService>(value),
    );
  }
}

String _$financeApiServiceHash() => r'39d1a059304b010195ce44f56009de997b6e0bad';

@ProviderFor(financeRepository)
final financeRepositoryProvider = FinanceRepositoryProvider._();

final class FinanceRepositoryProvider
    extends
        $FunctionalProvider<
          FinanceRepository,
          FinanceRepository,
          FinanceRepository
        >
    with $Provider<FinanceRepository> {
  FinanceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeRepositoryHash();

  @$internal
  @override
  $ProviderElement<FinanceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinanceRepository create(Ref ref) {
    return financeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinanceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinanceRepository>(value),
    );
  }
}

String _$financeRepositoryHash() => r'184f044ff44144beb2ee36f901b9974bb75a7eb6';
