import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/debt_model.dart';
part 'debt_state.freezed.dart';
@freezed
abstract class DebtState with _$DebtState {
  const factory DebtState({
    @Default([]) List<DebtModel> debts,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _DebtState;
}
