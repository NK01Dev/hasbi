import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/stats_provider.dart';
import '../../providers/transaction_provider.dart';
import 'custom_range_dialog.dart';

class CustomRangeSelector extends ConsumerWidget {
  final DateTimeRange? customRange;

  const CustomRangeSelector({
    super.key,
    required this.customRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _showCustomRangeDialog(context, ref),
      child: Container(
        padding: EdgeInsets.all(SpacingHelper.md + SpacingHelper.xs),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SpacingHelper.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeaderRow(),
            if (customRange != null) ...[
              SizedBox(height: SpacingHelper.xs),
              _buildSelectedRangeDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(SpacingHelper.xs),
          decoration: BoxDecoration(
            color: const Color(0xFF5B7FFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(SpacingHelper.xs),
          ),
          child: Icon(
            Icons.calendar_month_outlined,
            color: const Color(0xFF5B7FFF),
            size: SpacingHelper.iconSizeSmall,
          ),
        ),
        SizedBox(width: SpacingHelper.xs),
        Expanded(
          child: Text(
            customRange == null ? 'Select Custom Date Range' : 'Custom Range Selected',
            style: TextStyleHelper.textStyle14(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Icon(
          customRange != null ? Icons.edit_outlined : Icons.arrow_forward_ios,
          color: Colors.grey.shade400,
          size: customRange != null ? SpacingHelper.iconSizeSmall : 16.sp,
        ),
      ],
    );
  }

  Widget _buildSelectedRangeDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingHelper.md,
        vertical: SpacingHelper.xxs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B7FFF).withOpacity(0.06),
        borderRadius: BorderRadius.circular(SpacingHelper.sm),
        border: Border.all(
          color: const Color(0xFF5B7FFF).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMM dd').format(customRange!.start),
            style: TextStyleHelper.textStyle13(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5B7FFF),
            ),
          ),
          Text(
            'To',
            style: TextStyleHelper.textStyle11(
              color: Colors.grey.shade500,
            ),
          ),
          Text(
            DateFormat('MMM dd, yyyy').format(customRange!.end),
            style: TextStyleHelper.textStyle13(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5B7FFF),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomRangeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomRangeDialog(initialRange: customRange);
      },
    );
  }
}