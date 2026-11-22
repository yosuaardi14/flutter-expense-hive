import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';

class YearMonthFilter extends StatelessWidget {
  final String yearValue;
  final String monthValue;
  final List<String> listYear;
  final void Function(String? value)? onChangedYear;
  final void Function(String? value)? onChangedMonth;

  const YearMonthFilter({
    super.key,
    required this.yearValue,
    required this.monthValue,
    required this.listYear,
    this.onChangedYear,
    this.onChangedMonth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: yearValue,
            items: [
              ...listYear.map(
                (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
              ),
            ],
            decoration: const InputDecoration(labelText: 'Tahun'),
            onChanged: onChangedYear,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: monthValue,
            items: [
              ...Constant.dropdownMonthOnly.entries.map(
                (e) => DropdownMenuItem<String>(
                  value: e.key,
                  child: Text(e.value),
                ),
              ),
            ],
            decoration: const InputDecoration(labelText: 'Bulan'),
            onChanged: onChangedMonth,
          ),
        ),
      ],
    );
  }
}
