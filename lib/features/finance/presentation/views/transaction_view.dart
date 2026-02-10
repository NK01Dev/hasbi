import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:hasbi/core/theme/spacing_helper.dart';
import 'package:hasbi/core/theme/text_styles.dart';
import 'package:hasbi/features/finance/data/models/finance_enums.dart';
import 'package:hasbi/features/finance/presentation/widgets/transaction_tile.dart';
import 'package:hasbi/features/finance/presentation/widgets/filter_mode_selector.dart';
import 'package:hasbi/features/finance/presentation/widgets/day_timeline_widget.dart';
import 'package:hasbi/features/finance/presentation/widgets/custom_range_selector.dart';
import 'package:hasbi/features/finance/presentation/widgets/dashboard_animations.dart';
import 'package:hasbi/features/finance/providers/transaction_provider.dart';
import 'package:hasbi/core/common/widgets/empty_widget.dart';

 class TransactionView extends ConsumerWidget {
   const TransactionView({super.key});

   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final selectedDate = ref.watch(transactionDateProvider);
     final filterMode = ref.watch(transactionFilterProvider);
     final customRange = ref.watch(transactionRangeProvider);
     final asyncTransactions = ref.watch(transactionsProvider);

     return SafeArea(
       child: SingleChildScrollView(
         physics: const BouncingScrollPhysics(),
         child: Padding(
           padding: SpacingHelper.pAllMedium,
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Filter Mode Selector
               StaggeredEntrance(
                 index: 1,
                 child: FilterModeSelector(currentMode: filterMode),
               ),
               SizedBox(height: SpacingHelper.md),

               // Date Timeline
               StaggeredEntrance(
                 index: 2,
                 child: _buildDateTimeline(filterMode, selectedDate, customRange, ref),
               ),
               SizedBox(height: SpacingHelper.lg),

               // Transactions Header
               StaggeredEntrance(
                 index: 3,
                 child: _TransactionsHeader(
                   filterMode: filterMode,
                   selectedDate: selectedDate,
                   customRange: customRange,
                 ),
               ),
               SizedBox(height: SpacingHelper.xs),

               // Transaction List
               _TransactionsList(asyncTransactions: asyncTransactions),
             ],
           ),
         ),
       ),
     );
   }

   Widget _buildDateTimeline(
       DateFilterMode mode,
       DateTime selectedDate,
       DateTimeRange? customRange,
       WidgetRef ref,
       )
   {
     switch (mode) {
       case DateFilterMode.day:
         return DayTimelineWidget(selectedDate: selectedDate);
       case DateFilterMode.customRange:
         return CustomRangeSelector(customRange: customRange);
     }
   }
 }

 // ==========================================
 // Transactions Header Widget
 // ==========================================
 class _TransactionsHeader extends StatelessWidget {
   final DateFilterMode filterMode;
   final DateTime selectedDate;
   final DateTimeRange? customRange;

   const _TransactionsHeader({
     required this.filterMode,
     required this.selectedDate,
     required this.customRange,
   });

   @override
   Widget build(BuildContext context) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(
           'Transactions',
           style: TextStyleHelper.textStyle16(fontWeight: FontWeight.w600),
         ),
         Text(
           _getFilterLabel(),
           style: TextStyleHelper.textStyle12(color: Colors.grey),
         ),
       ],
     );
   }

   String _getFilterLabel() {
     switch (filterMode) {
       case DateFilterMode.day:
         return DateFormat('MMM dd, yyyy').format(selectedDate);
       case DateFilterMode.customRange:
         if (customRange == null) return 'Select range';
         final days = customRange!.end.difference(customRange!.start).inDays + 1;
         return '$days days selected';
     }
   }
 }

 // ==========================================
 // Transactions List Widget
 // ==========================================
 class _TransactionsList extends StatelessWidget {
   final AsyncValue asyncTransactions;

   const _TransactionsList({required this.asyncTransactions});

   @override
   Widget build(BuildContext context) {
     return asyncTransactions.when(
       data: (transactions) {
         if (transactions.isEmpty) {
           return Center(
             child: Padding(
               padding: EdgeInsets.only(top: SpacingHelper.xl),
               child: const EmptyWidget(),
             ),
           );
         }
         return Column(
           children: List.generate(transactions.length, (index) {
             return StaggeredEntrance(
               index: index + 4,
               child: TransactionTile(
                 transaction: transactions[index],
                 index: index,
               ),
             );
           }),
         );
       },
       loading: () => Center(
         child: Padding(
           padding: EdgeInsets.only(top: SpacingHelper.xl),
           child: const CircularProgressIndicator(),
         ),
       ),
       error: (error, stack) => _ErrorWidget(error: error),
     );
   }
 }

 // ==========================================
 // Error Widget
 // ==========================================
 class _ErrorWidget extends StatelessWidget {
   final Object error;

   const _ErrorWidget({required this.error});

   @override
   Widget build(BuildContext context) {
     return Center(
       child: Padding(
         padding: EdgeInsets.only(top: SpacingHelper.xl),
         child: Column(
           children: [
             const Icon(
               Icons.error_outline,
               color: Colors.red,
               size: 48,
             ),
             SizedBox(height: SpacingHelper.xs),
             Text(
               "Error: $error",
               style: const TextStyle(color: Colors.red),
               textAlign: TextAlign.center,
             ),
           ],
         ),
       ),
     );
   }
 }