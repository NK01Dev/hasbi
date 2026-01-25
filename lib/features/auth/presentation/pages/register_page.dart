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

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final fullNameController = useTextEditingController();
    // final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final ageController = useTextEditingController();
    final selectedGender = useState<String>("Male");
    final obscurePassword = useState(true);

    final authState = ref.watch(authProvider);

    // Listener
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.maybeWhen(
        error: (message) => AppFlushbar.showError(context, message),
        authenticated: (user) {
          AppFlushbar.showSuccess(context, "Welcome, ${user.fullName}!");
          _clearControllers([fullNameController, emailController, passwordController, ageController]);
          selectedGender.value = "Male";
          Future.delayed(const Duration(milliseconds: 800), () {
            if (context.mounted) context.go(AppRoutePaths.dashboard);
          });
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18.w),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600.w), // Max width for web/tablet
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SpacingHelper.lg),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Text(
                    "Create Account",
                    style: TextStyleHelper.textStyle24(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Fill in your details to get started",
                    style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 32.h),


                 _buildField(
                   fullNameController,
                          "Full Name",
                          Icons.person_outline,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),



                  SizedBox(height: 16.h),

                  // --- Contact ---
                  _buildField(
                    emailController,
                    "Email Address",
                    Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v!.isEmpty) return "Required";
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "Invalid email";
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  _buildField(
                    passwordController,
                    "Password",
                    Icons.lock_outline,
                    obscure: obscurePassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () => obscurePassword.value = !obscurePassword.value,
                      child: Icon(
                        obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: (v) => (v!.length < 6) ? "Min 6 characters" : null,
                  ),
                  SizedBox(height: 16.h),

                  // --- Personal Info Row ---

                        _buildField(
                          ageController,
                          "Age",
                          Icons.cake_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),

                  SizedBox(height: 16.h),
               _buildGenderSelector(selectedGender),

                  SizedBox(height: 32.h),

                  // --- Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: authState.maybeWhen(
                        loading: () => null,
                        orElse: () => () {
                          if (formKey.currentState?.validate() ?? false) {
                            final age = int.tryParse(ageController.text) ?? 0;
                            ref.read(authProvider.notifier).register(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              fullName: fullNameController.text.trim(),
                              age: age,
                              gender: selectedGender.value , // Default fallback
                            );
                          }
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: authState.maybeWhen(
                        loading: () => const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        ),
                        orElse: () => Text(
                          "Create Account",
                          style: TextStyleHelper.textStyle16(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // --- Footer ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyleHelper.textStyle14(color: AppColors.textSecondary),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          "Login",
                          style: TextStyleHelper.textStyle14(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool obscure = false,
        TextInputType? keyboardType,
        Widget? suffixIcon,
        String? Function(String?)? validator,
      }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyleHelper.textStyle14(color: AppColors.textPrimary),
      decoration: ThemeHelper.inputDecoration(
        label: label,
        prefixIcon: icon,
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  Widget _buildGenderSelector(ValueNotifier<String?> selectedGender) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Modern Pill Selector
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Male Option
              Expanded(
                child: GestureDetector(
                  onTap: () => selectedGender.value = "Male",
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: selectedGender.value == "Male"
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Male",
                      style: TextStyleHelper.textStyle14(
                        color: selectedGender.value == "Male" ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: selectedGender.value == "Male" ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              // Female Option
              Expanded(
                child: GestureDetector(
                  onTap: () => selectedGender.value = "Female",
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: selectedGender.value == "Female"
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Female",
                      style: TextStyleHelper.textStyle14(
                        color: selectedGender.value == "Female" ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: selectedGender.value == "Female" ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearControllers(List<TextEditingController> controllers) {
    for (var c in controllers) c.clear();
  }
}