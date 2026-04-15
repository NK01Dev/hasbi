import 'package:freezed_annotation/freezed_annotation.dart';

part 'summary_model.freezed.dart';
part 'summary_model.g.dart';

/// Server-computed financial summary returned by the `getSummary` action
/// of the consolidated `finance-api-v1` function.
@freezed
abstract class SummaryModel with _$SummaryModel {
  const factory SummaryModel({
    @Default(0.0) double totalIncome,
    @Default(0.0) double totalExpense,
    @Default(0.0) double balance,
    @Default({}) Map<String, double> incomesByCategory,
    @Default({}) Map<String, double> expensesByCategory,
  }) = _SummaryModel;

  factory SummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SummaryModelFromJson(json);
}
