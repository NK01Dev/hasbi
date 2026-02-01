import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/stats_provider.dart';
import '../../providers/transaction_provider.dart';

class CustomRangeDialog extends ConsumerStatefulWidget {
  final DateTimeRange? initialRange;

  const CustomRangeDialog({
    super.key,
    required this.initialRange,
  });

  @override
  ConsumerState<CustomRangeDialog> createState() => _CustomRangeDialogState();
}

class _CustomRangeDialogState extends ConsumerState<CustomRangeDialog> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectionMode = 'start';

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialRange?.start;
    _endDate = widget.initialRange?.end;
    _selectionMode = (_startDate == null) ? 'start' : 'end';
  }

  void _onDatePicked(DateTime date) {
    setState(() {
      if (_selectionMode == 'start') {
        _startDate = date;
        // If a start date is picked that is AFTER the current end date, reset end date
        if (_endDate != null && _startDate!.isAfter(_endDate!)) {
          _endDate = null;
        }
        _selectionMode = 'end';
      } else {
        // If an end date is picked that is BEFORE the start date,
        // treat it as the new start date instead.
        if (_startDate != null && date.isBefore(_startDate!)) {
          _startDate = date;
          _endDate = null;
          _selectionMode = 'end';
        } else {
          _endDate = date;
        }
      }
    });
  }
  void _resetDates() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _selectionMode = 'start';
    });
  }

  void _confirmSelection() {
    if (_startDate != null && _endDate != null) {
      final newRange = DateTimeRange(
        start: _startDate!,
        end: _endDate!,
      );
      ref.read(transactionRangeProvider.notifier).update(newRange);
      ref.read(transactionDateProvider.notifier).update(newRange.start);
      Navigator.of(context).pop();
    }
  }

  // Update your build method in CustomRangeDialog
  @override
  Widget build(BuildContext context) {
    final isConfirmEnabled = _startDate != null && _endDate != null;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingHelper.lg),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: SpacingHelper.md,
        vertical: SpacingHelper.xl,
      ),
      child: Container(
        // Remove fixed maxHeight constraint
        padding: EdgeInsets.all(SpacingHelper.md + SpacingHelper.xs),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SpacingHelper.lg),
        ),
        child: SingleChildScrollView( // Add this to prevent overflow
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              SizedBox(height: SpacingHelper.lg),
              _buildSelectionInstruction(),
              _buildDateChips(),
              // Remove the vertical spacing here if it feels too cramped
              _buildDateTimeline(),
              SizedBox(height: SpacingHelper.lg),
              _buildActionButtons(isConfirmEnabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeline() {
    return SizedBox(
      height: 330.h, // Reduced from 400.h to save space
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: _selectionMode == 'start' ? const Color(0xFF5B7FFF) : Colors.green,
            onPrimary: Colors.white,
            onSurface: Colors.black87,
          ),
          // This removes the extra padding inside the native picker
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: CalendarDatePicker(
          initialDate: (_selectionMode == 'start' ? _startDate : _endDate) ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: (DateTime date) {
            _onDatePicked(date);
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Select Range',
          style: TextStyleHelper.textStyle18(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.close, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSelectionInstruction() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingHelper.xs,
        vertical: SpacingHelper.xxs,
      ),
      decoration: BoxDecoration(
        color: _selectionMode == 'start'
            ? const Color(0xFF5B7FFF).withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SpacingHelper.xs),
      ),
      child: Row(
        children: [
          Icon(
            _selectionMode == 'start'
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 16.sp,
            color: _selectionMode == 'start'
                ? const Color(0xFF5B7FFF)
                : Colors.green,
          ),
          SizedBox(width: SpacingHelper.xs),
          Text(
            _selectionMode == 'start' ? 'Select Start Date' : 'Select End Date',
            style: TextStyleHelper.textStyle13(
              color: _selectionMode == 'start'
                  ? const Color(0xFF5B7FFF)
                  : Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateChips() {
    if (_startDate != null || _endDate != null) {
      return Column(
        children: [
          SizedBox(height: SpacingHelper.md),
          Row(
            children: [
              _DateChip(
                date: _startDate,
                label: 'Start',
                isActive: _selectionMode == 'start',
                onTap: () => setState(() => _selectionMode = 'start'),
              ),
              SizedBox(width: SpacingHelper.xs),
              _DateChip(
                date: _endDate,
                label: 'End',
                isActive: _selectionMode == 'end',
                onTap: () => setState(() => _selectionMode = 'end'),
              ),
            ],
          ),
        ],
      );
    }
    return SizedBox(height: SpacingHelper.xl);
  }


  Widget _buildActionButtons(bool isConfirmEnabled) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetDates,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SpacingHelper.md),
              ),
              padding: EdgeInsets.symmetric(vertical: SpacingHelper.sm),
            ),
            child: Text(
              'Reset',
              style: TextStyleHelper.textStyle14(color: Colors.grey.shade600),
            ),
          ),
        ),
        SizedBox(width: SpacingHelper.xs),
        Expanded(
          child: ElevatedButton(
            onPressed: isConfirmEnabled ? _confirmSelection : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B7FFF),
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SpacingHelper.md),
              ),
              padding: EdgeInsets.symmetric(vertical: SpacingHelper.sm),
            ),
            child: Text(
              'Confirm',
              style: TextStyleHelper.textStyle14(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// Date Chip Widget
// ==========================================
class _DateChip extends StatelessWidget {
  final DateTime? date;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DateChip({
    required this.date,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: SpacingHelper.xs),
          decoration: BoxDecoration(
            color: isActive
                ? (label == 'Start'
                ? const Color(0xFF5B7FFF).withOpacity(0.1)
                : Colors.green.withOpacity(0.1))
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(SpacingHelper.xs),
            border: Border.all(
              color: isActive
                  ? (label == 'Start' ? const Color(0xFF5B7FFF) : Colors.green)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyleHelper.textStyle10(
                  color: isActive
                      ? (label == 'Start'
                      ? const Color(0xFF5B7FFF)
                      : Colors.green)
                      : Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                date != null ? DateFormat('MMM dd').format(date!) : '-',
                style: TextStyleHelper.textStyle13(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black87 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}