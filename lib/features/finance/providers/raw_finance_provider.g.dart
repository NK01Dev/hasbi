// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rawFinanceData)
final rawFinanceDataProvider = RawFinanceDataFamily._();

final class RawFinanceDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<FinanceRawData>,
          FinanceRawData,
          FutureOr<FinanceRawData>
        >
    with $FutureModifier<FinanceRawData>, $FutureProvider<FinanceRawData> {
  RawFinanceDataProvider._({
    required RawFinanceDataFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rawFinanceDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rawFinanceDataHash();

  @override
  String toString() {
    return r'rawFinanceDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FinanceRawData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FinanceRawData> create(Ref ref) {
    final argument = this.argument as String;
    return rawFinanceData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RawFinanceDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rawFinanceDataHash() => r'f70d6a0d8e4b6b7f5fe42b2a04b222bdbc0a0b41';

final class RawFinanceDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FinanceRawData>, String> {
  RawFinanceDataFamily._()
    : super(
        retry: null,
        name: r'rawFinanceDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RawFinanceDataProvider call(String userId) =>
      RawFinanceDataProvider._(argument: userId, from: this);

  @override
  String toString() => r'rawFinanceDataProvider';
}
