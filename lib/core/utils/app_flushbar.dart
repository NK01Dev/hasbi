import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../theme/spacing_helper.dart';

enum FlushbarType { info, success, error }

class AppFlushbar {
  /// Generic method to show a flushbar based on type
  static void show({
    required BuildContext context,
    required String message,
    required FlushbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Define styling based on type
    Color color;
    IconData icon;
    String title;

    switch (type) {
      case FlushbarType.success:
        color = Colors.green;
        icon = Icons.check_circle_outline;
        title = "Success";
        break;
      case FlushbarType.error:
        color = Colors.red;
        icon = Icons.error_outline;
        title = "Error";
        break;
      case FlushbarType.info:
        color = Colors.blue;
        icon = Icons.info_outline;
        title = "Info";
        break;
    }

    // Implementation using your requested style
    final flushbar = Flushbar(
      title: title,
      titleColor: color, // Use the type color for title
      message: message,
      messageColor: Colors.black87, // Dark grey for message body
      icon: Icon(
        icon,
        size: SpacingHelper.iconSizeMedium,
        color: color,
      ),
      duration: duration,
      leftBarIndicatorColor: color,
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: SpacingHelper.mAllSmall,
      borderRadius: BorderRadius.circular(SpacingHelper.xs),
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withAlpha(25), // withOpacity replacement for newer Flutter
          spreadRadius: 1,
          blurRadius: 5,
        )
      ],
    );

    flushbar.show(context);
  }

  // Convenience methods
  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: FlushbarType.error);
  }

  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: FlushbarType.success);
  }

  static void showInfo(BuildContext context, String message) {
    show(context: context, message: message, type: FlushbarType.info);
  }
}