import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/errors/finance_api_exception.dart';

/// Single entry-point for calling the consolidated `finance-api-v1` Appwrite
/// function.
///
/// Every call automatically generates a short-lived JWT so the backend can
/// verify the caller's identity.
class FinanceApiService {
  final Functions _functions;
  final Account _account;

  /// The deployed Appwrite function ID.
  static const String _functionId = 'finance-api-v1';

  FinanceApiService({required Functions functions, required Account account})
    : _functions = functions,
      _account = account;

  /// Maps a string HTTP method to the Appwrite [ExecutionMethod] enum.
  static ExecutionMethod _resolveMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return ExecutionMethod.gET;
      case 'PUT':
        return ExecutionMethod.pUT;
      case 'PATCH':
        return ExecutionMethod.pATCH;
      case 'DELETE':
        return ExecutionMethod.dELETE;
      case 'POST':
      default:
        return ExecutionMethod.pOST;
    }
  }

  /// Executes a single action against the consolidated finance API.
  ///
  /// [action]  – one of `getSummary`, `deleteTransaction`,
  ///             `contributeToGoal`, `exportCSV`.
  /// [data]    – additional payload fields merged alongside `action`.
  /// [method]  – HTTP method forwarded to the function (default `POST`).
  ///
  /// Returns the parsed JSON body on success (status 200).
  /// Throws [FinanceApiException] on any non-200 response.
  Future<Map<String, dynamic>> callFinanceApi({
    required String action,
    Map<String, dynamic> data = const {},
    String method = 'POST',
  }) async {
    // 1. Generate a short-lived JWT for secure backend authentication.
    final jwt = await _account.createJWT();

    // 2. Build the payload with the mandatory `action` key.
    final payload = <String, dynamic>{'action': action, ...data};

    debugPrint('FinanceApiService: calling action=$action');

    // 3. Execute the Appwrite function.
    final execution = await _functions.createExecution(
      functionId: _functionId,
      body: jsonEncode(payload),
      path: '/',
      method: _resolveMethod(method),
      headers: {
        'Authorization': 'Bearer ${jwt.jwt}',
        'Content-Type': 'application/json',
      },
    );

    // 4. Parse and return the result.
    final statusCode = execution.responseStatusCode;
    final body = execution.responseBody;

    if (statusCode == 200) {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        // If the response is not JSON (e.g. CSV), wrap it.
        return <String, dynamic>{'raw': body};
      }
    }

    debugPrint('FinanceApiService: action=$action failed ($statusCode): $body');

    throw FinanceApiException(
      statusCode: statusCode,
      message: 'Action "$action" failed with status $statusCode',
      responseBody: body,
    );
  }
}
