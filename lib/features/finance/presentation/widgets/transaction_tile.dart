import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountStr = '${transaction.isExpense ? '-' : '+'} \$ ${transaction.amount.toInt()}';
    final timeStr = DateFormat.jm().format(transaction.date);

    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              _handleEdit(context); // Call Edit
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(16.r),
          ),
          SlidableAction(
            onPressed: (context) {
              _handleDelete(context, ref);
            },
            backgroundColor: const Color(0xFFF44336),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(16.r),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: transaction.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                transaction.icon,
                color: transaction.color,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: TextStyleHelper.textStyle14(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  if (transaction.note != null && transaction.note!.isNotEmpty)
                    Text(
                      transaction.note!,
                      style: TextStyleHelper.textStyle12(
                        color: Colors.grey,
                      ),
                    )
                  else
                    Text(
                      timeStr,
                      style: TextStyleHelper.textStyle12(
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              amountStr,
              style: TextStyleHelper.textStyle16(
                fontWeight: FontWeight.bold,
                color: transaction.isExpense ? AppColors.error : AppColors.success,
              ),
            ),
          ],
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