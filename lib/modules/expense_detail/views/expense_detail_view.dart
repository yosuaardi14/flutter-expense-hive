import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/expense.dart';

class ExpenseDetailView extends StatelessWidget {
  final List<Expense>? data;
  const ExpenseDetailView({this.data, super.key});

  String rupiahFormat(double amount) {
    return NumberFormat.currency(locale: "id", decimalDigits: 0, symbol: "Rp ")
        .format(amount);
  }

  Widget itemData(Expense data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(data.title),
        subtitle: Text(data.type),
        leading: Chip(
          label: Text(
            data.payment.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        trailing: Chip(label: Text(rupiahFormat(data.amount.toDouble()))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: data?.map((e) => itemData(e)).toList() ?? [],
          ),
        ),
      ),
    );
  }
}
