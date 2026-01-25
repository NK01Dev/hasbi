import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Core
import '../../../../core/router/app_route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/spacing_helper.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/app_flushbar.dart';

// Domain
import '../providers/auth_provider.dart';
import '../states/auth_state.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final rememberMe = useState(false);
    final obscurePassword = useState(true);
    final authState = ref.watch(authProvider);

    // Listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        error: (message) => AppFlushbar.showError(context, message),
        authenticated: (_) {
          AppFlushbar.showSuccess(context, "Welcome back!");
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600.w), // Max width for web/tablet
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SpacingHelper.lg),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Header Section ---
                  SizedBox(height: SpacingHelper.xl),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 40.w,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: SpacingHelper.lg),
                  Text(
                    "Welcome Back",
                    style: TextStyleHelper.textStyle24(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SpacingHelper.xs),
                  Text(
                    "Log in to manage your finances easily",
                    textAlign: TextAlign.center,
                    style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: SpacingHelper.xxl),

                  // --- Form Card ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email Address",
                        style: TextStyleHelper.textStyle14(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: SpacingHelper.xs),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: ThemeHelper.inputDecoration(
                          hint: "Enter your email",
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Email is required";
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SpacingHelper.md),
                      Text(
                        "Password",
                        style: TextStyleHelper.textStyle14(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: SpacingHelper.xs),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword.value,
                        decoration: ThemeHelper.inputDecoration(
                          hint: "Enter your password",
                          prefixIcon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                              size: 20.w,
                            ),
                            onPressed: () => obscurePassword.value = !obscurePassword.value,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Password is required";
                          if (value.length < 6) return "Min 6 characters";
                          return null;
                        },
                      ),
                      SizedBox(height: SpacingHelper.sm),

                      // Remember Me & Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => rememberMe.value = !rememberMe.value,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.w,
                                  height: 20.w,
                                  child: Checkbox(
                                    value: rememberMe.value,
                                    onChanged: (v) => rememberMe.value = v ?? false,
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                                  ),
                                ),
                                SizedBox(width: SpacingHelper.xs),
                                Text("Remember me", style: TextStyleHelper.textStyle12(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRoutePaths.forgotPassword),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyleHelper.textStyle12(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SpacingHelper.lg),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: authState.maybeWhen(
                            loading: () => null,
                            orElse: () => () {
                              if (formKey.currentState?.validate() ?? false) {
                                ref.read(authProvider.notifier).login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  rememberMe: rememberMe.value,
                                );
                              }
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            elevation: 0,
                          ),
                          child: authState.maybeWhen(
                            loading: () => const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            ),
                            orElse: () => Text(
                              "Login",
                              style: TextStyleHelper.textStyle16(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SpacingHelper.xl),

                  // --- Social Login ---
                  Row(
                    children: [
                      const Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: SpacingHelper.md),
                        child: Text(
                          "Or continue with",
                          style: TextStyleHelper.textStyle12(color: AppColors.textSecondary),
                        ),
                      ),
                      const Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  SizedBox(height: SpacingHelper.lg),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: SpacingHelper.md),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.g_mobiledata_rounded, size: 24.w, color: AppColors.primary),
                          SizedBox(width: SpacingHelper.xs),
                          Flexible(
                            child: Text(
                              "Continue with Google",
                              style: TextStyleHelper.textStyle14(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SpacingHelper.xl),

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.push(AppRoutePaths.register),
                        child: Text(
                          "Register",
                          style: TextStyleHelper.textStyle14(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SpacingHelper.xl),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}