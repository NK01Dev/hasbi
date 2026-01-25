import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app.dart';
import 'core/storage/hive_service.dart';

void main() async {
  // 1. Initialize Hive & Storage
  await Hive.initFlutter();
  await HiveService().init();
  
  // 2. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Load the .env file
  await dotenv.load(fileName: ".env");

  // 3. Configure Logging
  Logger.root.level = Level.ALL; // Defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });


  runApp(const ProviderScope(child: AppwriteApp()));
}
