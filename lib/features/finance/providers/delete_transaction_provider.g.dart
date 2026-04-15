// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages soft-delete, restore, and confirmed hard-delete of transactions
/// through the consolidated `finance-api-v1` function.

@ProviderFor(DeleteTransactionNotifier)
final deleteTransactionProvider = DeleteTransactionNotifierProvider._();

/// Manages soft-delete, restore, and confirmed hard-delete of transactions
/// through the consolidated `finance-api-v1` function.
final class DeleteTransactionNotifierProvider
    extends $AsyncNotifierProvider<DeleteTransactionNotifier, void> {
  /// Manages soft-delete, restore, and confirmed hard-delete of transactions
  /// through the consolidated `finance-api-v1` function.
  DeleteTransactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTransactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTransactionNotifierHash();

  @$internal
  @override
  DeleteTransactionNotifier create() => DeleteTransactionNotifier();
}

String _$deleteTransactionNotifierHash() =>
    r'98d14fc4fa23e74f6d6dcef80674fdd97dc3f7b5';

/// Manages soft-delete, restore, and confirmed hard-delete of transactions
/// through the consolidated `finance-api-v1` function.

abstract class _$DeleteTransactionNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
