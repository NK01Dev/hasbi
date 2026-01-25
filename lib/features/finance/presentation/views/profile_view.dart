import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/app_route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../providers/dashboard_nav_provider.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Logout Listener: Redirects to login when unauthenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthStateUnauthenticated) {
        context.go(AppRoutePaths.root);
      }
    });

    // Extract User Data
    final user = authState.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              // 1. Header Section (User Info)
              _SingleSection(
                children: [
                  UserAccountsDrawerHeader(
                    margin: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.fullName[0] ?? "U",
                        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    accountName: Text(
                      user?.fullName ?? "User Name",
                      style: TextStyleHelper.textStyle18(color: Colors.white),
                    ),
                    accountEmail: Text(
                      user?.email ?? "Welcome back",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. General Section
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                    title: "Dark Mode",
                    icon: Icons.dark_mode_outlined,
                    trailing: Switch(
                      value: false, // Connect this to your theme provider later
                      onChanged: (value) {},
                    ),
                  ),
                  const _CustomListTile(
                    title: "Notifications",
                    icon: Icons.notifications_none_rounded,
                  ),
                ],
              ),

              const Divider(),

              // 3. Organization Section
              _SingleSection(
                title: "Organization",
                children: [
                  _CustomListTile(
                    title: "Back to Home",
                    icon: Icons.home_outlined,
                    onTap: () {
                      context.pop();
                      ref.read(navIndexProvider.notifier).setIndex(0);
                    },
                  ),
                  const _CustomListTile(
                    title: "My Statistics",
                    icon: Icons.bar_chart_rounded,
                  ),
                ],
              ),

              const Divider(),

              // 4. Account Actions Section
              _SingleSection(
                children: [
                  const _CustomListTile(
                    title: "Help & Feedback",
                    icon: Icons.help_outline_rounded,
                  ),
                  _CustomListTile(
                    title: "Sign out",
                    icon: Icons.exit_to_app_rounded,
                    color: Colors.red,
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      leading: Icon(icon, color: color),
      trailing: trailing ?? const Icon(Icons.chevron_right, size: 18),
      onTap: onTap ?? () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}