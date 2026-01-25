import 'package:appwrite/appwrite.dart';
import 'dart:io';

class ErrorMapper {
  /// Maps exceptions to user-friendly strings
  static String map(dynamic error) {
    // 1. Handle Appwrite Exceptions first (Most specific)
    if (error is AppwriteException) {
      return _mapAppwriteException(error);
    }

    // 2. Handle Network/IO Exceptions
    if (error is SocketException) {
      return "No internet connection. Please check your network.";
    }

    final errorStr = error.toString();
    
    // 3. Fallback: If the error was already stringified (e.g. by a previous catch block)
    if (errorStr.contains('AppwriteException')) {
      if (errorStr.contains('email')) return "Please enter a valid email address.";
      if (errorStr.contains('401')) return "Invalid email or password.";
      if (errorStr.contains('409')) return "An account with this email already exists.";
      if (errorStr.contains('network') || errorStr.contains('403')) {
         return "Connection error. Please check your internet or permissions.";
      }
    }
    
    // 4. Handle Timeout / General Network strings
    final lowerError = errorStr.toLowerCase();
    if (lowerError.contains('network_error') || 
        lowerError.contains('socketexception') || 
        lowerError.contains('failed host lookup')) {
      return "Network error. Please check your internet connection.";
    }
    
    if (lowerError.contains('timeout')) {
      return "The server is taking too long to respond. Please try again.";
    }

    // 5. Generic Fallback
    return "An unexpected error occurred. Please try again.";
  }

  static String _mapAppwriteException(AppwriteException e) {
    // Priority 1: Check by Type (Specific Appwrite Error Code)
    // This is the most reliable way to identify the exact cause
    switch (e.type) {
      case 'user_already_exists':
      case 'user_email_already_exists':
        return "An account with this email already exists.";
      case 'user_invalid_credentials':
        return "Invalid email or password.";
      case 'user_not_found':
        return "No account found with this email.";
      case 'user_password_mismatch':
        return "The password you entered is incorrect.";
      case 'user_session_already_exists':
        return "You are already logged in.";
      case 'document_not_found':
        return "Data not found. It may have been deleted.";
      case 'rate_limit_exceeded':
        return "Too many attempts. Please wait a moment.";
    }

    // Priority 2: Check by HTTP Status Code (General Categories)
    switch (e.code) {
      case 400: // Bad Request - Map specific fields if possible
        return _mapBadRequest(e);
      case 401: // Unauthorized
        return "Access denied. Please login again.";
      case 403: // Forbidden
        return "Permission denied for this action.";
      case 404: // Not Found
        return "The requested information was not found.";
      case 409: // Conflict
        return "A conflict occurred. The data might already exist.";
      case 429: // Too Many Requests
        return "Too many attempts. Please try again later.";
      case 500: // Internal Server Error
      case 503:
        return "Server is currently unavailable. Please try later.";
    }

    // Priority 3: Fallback (Use message if it's short, otherwise generic)
    if (e.message != null && e.message!.length < 50) {
      return e.message!;
    }

    return "An error occurred with the authentication service.";
  }

  static String _mapBadRequest(AppwriteException e) {
    final msg = e.message?.toLowerCase() ?? '';
    
    if (msg.contains('email')) {
      return "Please enter a valid email address.";
    }
    if (msg.contains('password')) {
      return "Password must be at least 8 characters long.";
    }
    if (msg.contains('firstname') || msg.contains('lastname')) {
      return "Please enter your full name correctly.";
    }
    
    return "The information provided is invalid. Please check and try again.";
  }
}
