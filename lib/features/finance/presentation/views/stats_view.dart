import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/app_colors.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/features/finance/presentation/widgets/finance_stat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatsView extends HookConsumerWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Persistent state for the current selection (Default: 3 for Month)
    final selectedFilter = useState(3);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Statistics',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: GestureDetector(
                onTap: () {}, // Handle calendar picker
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: SpacingHelper.pAllMedium,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // --- CUSTOM SLIDING SEGMENTED CONTROL ---
                Center(
                  child: CustomSlidingSegmentedControl<int>(
                    initialValue: selectedFilter.value,
                    children: {
                      1: _buildSegmentText('DAY'),
                      2: _buildSegmentText('WEEK'),
                      3: _buildSegmentText('MONTH'),
                      4: _buildSegmentText('YEAR'),
                    },
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F6), // Light grey background from image
                      borderRadius: BorderRadius.circular(20),
                    ),
                    thumbDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    onValueChanged: (v) {
                      selectedFilter.value = v;
                      // Logic: Trigger your Riverpod provider filter update here
                    },
                  ),
                ),
                // Rest of your body UI...
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for the text style inside segments
  Widget _buildSegmentText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}