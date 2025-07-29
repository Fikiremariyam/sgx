import 'package:flutter/material.dart';

enum TransactionType { Credit, Debt }

class Transaction {
  final String transType;
  final String transDate;
  final String transRefNo;
  final String openingBalance;
  final String currentBalance;
  final String amountCredited;
  final String amountDebited;

  Transaction({
    required this.transType,
    required this.transDate,
    required this.transRefNo,
    required this.openingBalance,
    required this.currentBalance,
    required this.amountCredited,
    required this.amountDebited,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transType: json['trans_type'],
      transDate: json['trans_date'],
      transRefNo: json['trans_refno'],
      openingBalance: json['opening_balance'],
      currentBalance: json['current_balance'],
      amountCredited: json['amount_credited'],
      amountDebited: json['amount_debited'],
    );
  }
}
