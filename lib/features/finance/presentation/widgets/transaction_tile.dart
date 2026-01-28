import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../providers/stats_provider.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionDisplayModel transaction;

  const TransactionTile({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Format amount (e.g., -$750)
    final amountStr = '${transaction.isExpense ? '-' : '+'} \$ ${transaction.amount.toInt()}';

    // Format time (e.g., 10:30 AM)
    final timeStr = DateFormat.jm().format(transaction.date);

    return Slidable(
      key: ValueKey(transaction.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // Edit Action
          SlidableAction(
            onPressed: (context) {
              _handleEdit(context, ref);
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            borderRadius: BorderRadius.circular(16.r),
          ),
          // Delete Action
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
            // Left: Icon
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

            // Middle: Title & Note
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

            // Right: Amount
            Text(
              amountStr,
              style: TextStyleHelper.textStyle16(
                fontWeight: FontWeight.bold,
                color: transaction.isExpense ? Colors.black87 : const Color(0xff22c55e),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleEdit(BuildContext context, WidgetRef ref) {
    // TODO: Navigate to edit screen or show edit dialog
    // You'll need to implement your edit screen/dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${transaction.title}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Example navigation (uncomment and adjust as needed):
    // if (transaction.isExpense) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => EditExpenseScreen(transactionId: transaction.id),
    //     ),
    //   );
    // } else {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => EditIncomeScreen(transactionId: transaction.id),
    //     ),
    //   );
    // }
  }

  void _handleDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: Text('Are you sure you want to delete "${transaction.title}"?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyleHelper.textStyle14(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                // TODO: Call your delete method from the repository
                // Example:
                // try {
                //   final repository = ref.read(financeRepositoryProvider);
                //   if (transaction.isExpense) {
                //     await repository.deleteExpense(transaction.id);
                //   } else {
                //     await repository.deleteIncome(transaction.id);
                //   }
                //
                //   // Refresh the stats
                //   ref.invalidate(statsNotifierProvider);
                //
                //   if (context.mounted) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text('Transaction deleted successfully'),
                //         behavior: SnackBarBehavior.floating,
                //       ),
                //     );
                //   }
                // } catch (e) {
                //   if (context.mounted) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text('Error: $e'),
                //         backgroundColor: Colors.red,
                //         behavior: SnackBarBehavior.floating,
                //       ),
                //     );
                //   }
                // }

                // Temporary placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleted ${transaction.title}'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: TextStyleHelper.textStyle14(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}