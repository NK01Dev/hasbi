// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_csv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a CSV export of the user's transactions from the consolidated API.
///
/// Returns the raw CSV string content.

@ProviderFor(exportCsv)
final exportCsvProvider = ExportCsvFamily._();

/// Fetches a CSV export of the user's transactions from the consolidated API.
///
/// Returns the raw CSV string content.

final class ExportCsvProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Fetches a CSV export of the user's transactions from the consolidated API.
  ///
  /// Returns the raw CSV string content.
  ExportCsvProvider._({
    required ExportCsvFamily super.from,
    required ({String userId, DateTime? startDate, DateTime? endDate})
    super.argument,
  }) : super(
         retry: null,
         name: r'exportCsvProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exportCsvHash();

  @override
  String toString() {
    return r'exportCsvProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument =
        this.argument
            as ({String userId, DateTime? startDate, DateTime? endDate});
    return exportCsv(
      ref,
      userId: argument.userId,
      startDate: argument.startDate,
      endDate: argument.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExportCsvProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exportCsvHash() => r'27875e9cdec570dc8208e384cbc35c66e76fb516';

/// Fetches a CSV export of the user's transactions from the consolidated API.
///
/// Returns the raw CSV string content.

final class ExportCsvFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<String>,
          ({String userId, DateTime? startDate, DateTime? endDate})
        > {
  ExportCsvFamily._()
    : super(
        retry: null,
        name: r'exportCsvProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a CSV export of the user's transactions from the consolidated API.
  ///
  /// Returns the raw CSV string content.

  ExportCsvProvider call({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) => ExportCsvProvider._(
    argument: (userId: userId, startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'exportCsvProvider';
}
