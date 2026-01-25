import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/app_flushbar.dart';


class ForgotPasswordPage extends HookConsumerWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: SpacingHelper.pHMedium,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter your email to receive a recovery link", style: TextStyleHelper.textStyle14()),
            SizedBox(height: SpacingHelper.lg),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: SpacingHelper.xl),
            SizedBox(
              width: double.infinity,
              height: SpacingHelper.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  // Logic to call Appwrite createRecovery
                  AppFlushbar.showSuccess(
                    context,
                    "Recovery link sent to ${emailController.text.trim()}",
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) context.pop();
                  });
                },
                child: const Text("Send Link"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}