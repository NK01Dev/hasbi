import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/finance_provider.dart';
import '../../providers/home_provider.dart';
import 'package:hasbi/features/finance/data/models/transaction_display_model.dart';
import '../../providers/stats_provider.dart';
import '../../providers/transaction_provider.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionDisplayModel transaction;
  final int index;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountStr = '${transaction.isExpense ? '-' : '+'} \$ ${transaction.amount.toStringAsFixed(0)}';
    final timeStr = DateFormat.jm().format(transaction.date);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Slidable(
          key: ValueKey(transaction.id),
          startActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _handleEdit(context),
                backgroundColor: AppColors.info.withOpacity(0.9),
                foregroundColor: Colors.white,
                icon: Icons.edit_rounded,
                label: 'Edit',
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.25,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _handleDelete(context, ref),
                backgroundColor: AppColors.error.withOpacity(0.9),
                foregroundColor: Colors.white,
                icon: Icons.delete_rounded,
                label: 'Delete',
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {}, // Future: Add detail view or edit on tap
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: transaction.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        transaction.icon,
                        color: transaction.color,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleHelper.textStyle16(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            transaction.note?.isNotEmpty == true ? transaction.note! : timeStr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyleHelper.textStyle12(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Amount
                    Text(
                      amountStr,
                      style: TextStyleHelper.textStyle16(
                        fontWeight: FontWeight.w800,
                        color: transaction.isExpense ? AppColors.error : AppColors.success,
                      ),
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

  void _handleEdit(BuildContext context) {
    // Determine route based on type
    final path = transaction.isExpense
        ? '/edit-expense/${transaction.id}'
        : '/edit-income/${transaction.id}';

    // Use GoRouter to push
    context.push(path);
  }

  void _handleDelete(BuildContext context, WidgetRef ref) async {
    // Optional: Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final repository = ref.read(financeRepositoryProvider);

        if (transaction.isExpense) {
          await repository.deleteExpense(transaction.id);
        } else {
          await repository.deleteIncome(transaction.id);
        }

        // Invalidate stats to refresh the list
        ref.invalidate(statisticsProvider);
        // Invalidate transactions to refresh the list
        ref.invalidate(transactionsProvider);
        // Also invalidate home provider if it calculates totals
        ref.invalidate(homeProvider);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Transaction deleted')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}