import 'package:appwrite/appwrite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'environment.dart';

part 'appwrite_config.g.dart';

@Riverpod(keepAlive: true)
Client appwriteClient(Ref ref) {
  return Client()
      .setEndpoint(Environment.appwritePublicEndpoint)
      .setProject(Environment.appwriteProjectId)
      .setSelfSigned(status: true);
}

@Riverpod(keepAlive: true)
Account appwriteAccount(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
}

@Riverpod(keepAlive: true)
Databases appwriteDatabases(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
}

@Riverpod(keepAlive: true)
Functions appwriteFunctions(Ref ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
}
