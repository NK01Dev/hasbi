import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum TransactionType {
  income('income'),
  expense('expense'),
  goals('goals');

  final String value;
  const TransactionType(this.value);
}

@JsonEnum(valueField: 'value')
enum Frequency {
  daily('daily'),
  weekly('weekly'),
  monthly('monthly'),
  yearly('yearly');

  final String value;
  const Frequency(this.value);
}

@JsonEnum(valueField: 'value')
enum DebtStatus {
  unpaid('unpaid'),
  partial('partial'),
  paid('paid');

  final String value;
  const DebtStatus(this.value);
}

@JsonEnum(valueField: 'value')
enum GoalStatus {
  //  active,  completed,  paused,cancelled
  active('active'),
  reached('reached'),
  paused('paused'),
  cancelled('cancelled'),
  failed('failed');

  final String value;
  const GoalStatus(this.value);
}

enum DateFilterMode { day, customRange }
