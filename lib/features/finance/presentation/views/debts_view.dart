import 'package:flutter/material.dart';
import 'package:hasbi/core/common/widgets/empty_widget.dart';
import 'package:hasbi/core/storage/hive_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../generated/assets.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../viewmodels/ debt_viewmodel.dart';
import '../viewmodels/debt_state.dart';

class DebtsView extends HookConsumerWidget {
  const DebtsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hiveService = HiveService();
    final user = ref.watch(currentUserProvider).value;
    final debtState = ref.watch(debtViewModelProvider);

    // Get the ID for use in the delete callback
    final userId = user?.id ?? hiveService.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("Debts")), // Added for better UI
      body: SafeArea(
        // Pass userId to the body builder
        child: _buildBody(ref, debtState, userId),
      ),
    );
  }

  Widget _buildBody(WidgetRef ref, DebtState state, String? userId) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return ErrorWidget('Error: ${state.errorMessage}');

    }

    if (state.debts.isEmpty) {
      return  EmptyWidget(
        lottieAsset: Assets.animationsEmpty,
        message: 'No debts found',

      );
        //const Center(child: Text('No debts found'));


    }

    return ListView.builder(
      itemCount: state.debts.length,
      itemBuilder: (context, index) {
        final debt = state.debts[index];
        return ListTile(
          title: Text(debt.fullName),
          subtitle: Text('\$${debt.amount}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if (userId != null) {
                ref.read(debtViewModelProvider.notifier)
                    .deleteDebt(debt.id, userId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error: User not identified")),
                );
              }
            },
          ),
        );
      },
    );
  }
}