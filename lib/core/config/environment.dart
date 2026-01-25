import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  // We use getters to access the dotenv map safely
  static String get appwritePublicEndpoint {
    final val = dotenv.env['APPWRITE_ENDPOINT'];
    if (val == null) debugPrint('WARNING: APPWRITE_ENDPOINT not found in .env');
    return val ?? 'https://cloud.appwrite.io/v1';
  }

  static String get appwriteProjectId {
    final val = dotenv.env['APPWRITE_PROJECT_ID'];
    if (val == null) debugPrint('WARNING: APPWRITE_PROJECT_ID not found in .env');
    return val ?? 'missing_project_id';
  }

  static String get appwriteProjectName {
    return dotenv.env['APPWRITE_PROJECT_NAME'] ?? 'Hasbi';
  }

  // Database IDs from DbConstants or .env
  static String get appwriteDatabaseId {
    return dotenv.env['APPWRITE_DATABASE_ID'] ?? 'finance_db';
  }

  static String get appwriteCollectionId {
    return dotenv.env['APPWRITE_COLLECTION_ID'] ?? 'users';
  }
}