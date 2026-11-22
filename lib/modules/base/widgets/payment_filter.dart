import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';

class PaymentFilter extends StatefulWidget {
  final bool Function(String value) isSelected;
  final void Function(bool value, String payment) onSelected;

  const PaymentFilter({
    super.key,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<PaymentFilter> createState() => _PaymentFilterState();
}

class _PaymentFilterState extends State<PaymentFilter> {
  final paymentList = Constant.dropdownPayment.sublist(1);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 5,
      children: paymentList
          .map(
            (e) => ChoiceChip(
              selectedColor: Colors.purple,
              label: SizedBox(
                width:
                    mediaQuery.width / paymentList.length -
                    paymentList.length * 5,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              selected: widget.isSelected(e),
              onSelected: (value) {
                widget.onSelected(value, e);
              },
            ),
          )
          .toList(),
    );
  }
}
