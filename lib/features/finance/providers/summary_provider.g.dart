// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches a server-computed financial summary from `finance-api-v1`.
///
/// This is a family provider keyed by `(userId, period)`.
/// Optionally, pass an anchor date for custom time ranges.

@ProviderFor(SummaryNotifier)
final summaryProvider = SummaryNotifierFamily._();

/// Fetches a server-computed financial summary from `finance-api-v1`.
///
/// This is a family provider keyed by `(userId, period)`.
/// Optionally, pass an anchor date for custom time ranges.
final class SummaryNotifierProvider
    extends $AsyncNotifierProvider<SummaryNotifier, SummaryModel> {
  /// Fetches a server-computed financial summary from `finance-api-v1`.
  ///
  /// This is a family provider keyed by `(userId, period)`.
  /// Optionally, pass an anchor date for custom time ranges.
  SummaryNotifierProvider._({
    required SummaryNotifierFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'summaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$summaryNotifierHash();

  @override
  String toString() {
    return r'summaryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  SummaryNotifier create() => SummaryNotifier();

  @override
  bool operator ==(Object other) {
    return other is SummaryNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$summaryNotifierHash() => r'8a9089a0ab9e22af10ef1f6609bea78383f5dddb';

/// Fetches a server-computed financial summary from `finance-api-v1`.
///
/// This is a family provider keyed by `(userId, period)`.
/// Optionally, pass an anchor date for custom time ranges.

final class SummaryNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SummaryNotifier,
          AsyncValue<SummaryModel>,
          SummaryModel,
          FutureOr<SummaryModel>,
          (String, String)
        > {
  SummaryNotifierFamily._()
    : super(
        retry: null,
        name: r'summaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches a server-computed financial summary from `finance-api-v1`.
  ///
  /// This is a family provider keyed by `(userId, period)`.
  /// Optionally, pass an anchor date for custom time ranges.

  SummaryNotifierProvider call(String userId, String period) =>
      SummaryNotifierProvider._(argument: (userId, period), from: this);

  @override
  String toString() => r'summaryProvider';
}

/// Fetches a server-computed financial summary from `finance-api-v1`.
///
/// This is a family provider keyed by `(userId, period)`.
/// Optionally, pass an anchor date for custom time ranges.

abstract class _$SummaryNotifier extends $AsyncNotifier<SummaryModel> {
  late final _$args = ref.$arg as (String, String);
  String get userId => _$args.$1;
  String get period => _$args.$2;

  FutureOr<SummaryModel> build(String userId, String period);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SummaryModel>, SummaryModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SummaryModel>, SummaryModel>,
              AsyncValue<SummaryModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
