import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Using screenutil from your snippet (.r)
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Recommended for images

import '../../../../core/router/app_route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/models/user_model.dart';
import '../providers/user_provider.dart';

class HomeHeaderWidget extends ConsumerWidget {
  const HomeHeaderWidget({super.key});

  String _formatDate(DateTime date) {
    // Output format: Mon, 11 Jan 2026
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final String currentDateString = _formatDate(DateTime.now());

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Profile Avatar
            GestureDetector(
              // Optional: Navigate to Profile Page
              onTap: () {
                context.push(AppRoutePaths.profile);
                // Scaffold.of(context).openDrawer();
              },
              child: CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                backgroundImage: _getAvatarProvider(user),
                child: user.userAvatar == null || user.userAvatar!.isEmpty
                    ? Icon(Icons.person, color: AppColors.primary, size: 24.w)
                    : null, // Hide icon if image exists
              ),
            ),
            SizedBox(width: 15.w),
            // Greeting & Date Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName, // Uses fullName from UserModel
                    style: TextStyleHelper.textStyle24(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),

                  Text(
                    currentDateString,
                    style: TextStyleHelper.textStyle14(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // User Name: Kamal
                ],
              ),
            ),
          ],
        );
      },
      loading: () => _buildSkeleton(),
      error: (error, stack) => _buildError(),
    );
  }

  // --- Helper Methods ---

  ImageProvider? _getAvatarProvider(UserModel user) {
    if (user.userAvatar != null && user.userAvatar!.isNotEmpty) {
      return CachedNetworkImageProvider(user.userAvatar!);
    }
    return null;
  }

  Widget _buildSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 100.w, height: 14.h, color: Colors.grey[300]),
            SizedBox(height: 8.h),
            Container(width: 120.w, height: 24.h, color: Colors.grey[300]),
          ],
        ),
        CircleAvatar(radius: 20.r, backgroundColor: Colors.grey[300]),
      ],
    );
  }

  Widget _buildError() {
    // Fallback UI if data fetch fails
    return Row(
      children: [
        Text(
          "Welcome!",
          style: TextStyleHelper.textStyle24(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10.w),
        const Icon(Icons.error_outline, color: Colors.red),
      ],
    );
  }
}
