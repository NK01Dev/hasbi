import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/stats_provider.dart';

class FilterModeSelector extends ConsumerWidget {
  final DateFilterMode currentMode;

  const FilterModeSelector({
    super.key,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(SpacingHelper.xxs),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(SpacingHelper.md),
      ),
      child: Row(
        children: [
          _ModeButton(
            label: 'Day',
            filterMode: DateFilterMode.day,
            isSelected: currentMode == DateFilterMode.day,
          ),
          _ModeButton(
            label: 'Custom',
            filterMode: DateFilterMode.customRange,
            isSelected: currentMode == DateFilterMode.customRange,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends ConsumerWidget {
  final String label;
  final DateFilterMode filterMode;
  final bool isSelected;

  const _ModeButton({
    required this.label,
    required this.filterMode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(statsFilterProvider.notifier).setMode(filterMode);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SpacingHelper.xs),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(SpacingHelper.sm),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyleHelper.textStyle13(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}