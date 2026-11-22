import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';

class PaymentFilter extends StatelessWidget {
  final bool Function(String value) isSelected;
  final void Function(bool value, String payment) onSelected;

  const PaymentFilter({
    super.key,
    required this.isSelected,
    required this.onSelected,
  });

  static final paymentList = List.unmodifiable(
    Constant.dropdownPayment.sublist(1),
  );

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.sizeOf(context).width;
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 5,
      children: paymentList
          .map(
            (e) => ChoiceChip(
              selectedColor: Colors.purple,
              label: SizedBox(
                width:
                    mediaQueryWidth / paymentList.length -
                    paymentList.length * 5,
                child: Text(
                  e,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              selected: isSelected(e),
              onSelected: (value) {
                onSelected(value, e);
              },
            ),
          )
          .toList(),
    );
  }
}
