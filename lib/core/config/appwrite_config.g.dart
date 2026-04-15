// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appwrite_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appwriteClient)
final appwriteClientProvider = AppwriteClientProvider._();

final class AppwriteClientProvider
    extends $FunctionalProvider<Client, Client, Client>
    with $Provider<Client> {
  AppwriteClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteClientHash();

  @$internal
  @override
  $ProviderElement<Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Client create(Ref ref) {
    return appwriteClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Client>(value),
    );
  }
}

String _$appwriteClientHash() => r'1e47b88ecf26763e2fe914b10dd45e8d38942f62';

@ProviderFor(appwriteAccount)
final appwriteAccountProvider = AppwriteAccountProvider._();

final class AppwriteAccountProvider
    extends $FunctionalProvider<Account, Account, Account>
    with $Provider<Account> {
  AppwriteAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteAccountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteAccountHash();

  @$internal
  @override
  $ProviderElement<Account> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Account create(Ref ref) {
    return appwriteAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Account value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Account>(value),
    );
  }
}

String _$appwriteAccountHash() => r'a48ca6ec16275da6321f82a8a3ebaa2d291423de';

@ProviderFor(appwriteDatabases)
final appwriteDatabasesProvider = AppwriteDatabasesProvider._();

final class AppwriteDatabasesProvider
    extends $FunctionalProvider<Databases, Databases, Databases>
    with $Provider<Databases> {
  AppwriteDatabasesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteDatabasesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteDatabasesHash();

  @$internal
  @override
  $ProviderElement<Databases> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Databases create(Ref ref) {
    return appwriteDatabases(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Databases value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Databases>(value),
    );
  }
}

String _$appwriteDatabasesHash() => r'9d966b129f5456243e7ee23bcfc098cae52de7b6';

@ProviderFor(appwriteFunctions)
final appwriteFunctionsProvider = AppwriteFunctionsProvider._();

final class AppwriteFunctionsProvider
    extends $FunctionalProvider<Functions, Functions, Functions>
    with $Provider<Functions> {
  AppwriteFunctionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appwriteFunctionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appwriteFunctionsHash();

  @$internal
  @override
  $ProviderElement<Functions> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Functions create(Ref ref) {
    return appwriteFunctions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Functions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Functions>(value),
    );
  }
}

String _$appwriteFunctionsHash() => r'a7c714b9a88d951ed607e1f8bb42c5689eef39a8';
