import 'package:flutter/material.dart';

class TransactionDisplayModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String? note;
  final Color color;
  final IconData icon;
  final bool isExpense;

  TransactionDisplayModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.note,
    required this.color,
    required this.icon,
    required this.isExpense,
  });
}
