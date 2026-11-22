import 'package:flutter/material.dart';
import 'package:flutter_expense_app/utils/constant.dart';

class ModeTypeFilter extends StatelessWidget {
  final String modeValue;
  final String typeValue;
  final bool showTypeFilter;
  final void Function(String? value) onChangedMode;
  final void Function(String? value) onChangedType;

  const ModeTypeFilter({
    super.key,
    required this.modeValue,
    required this.typeValue,
    required this.showTypeFilter,
    required this.onChangedMode,
    required this.onChangedType,
  });

  static final _modeItems = List<DropdownMenuItem<String>>.unmodifiable(
    Constant.mode.map(
      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
    ),
  );

  static final _typeItems = List<DropdownMenuItem<String>>.unmodifiable(
    Constant.dropdownType.map(
      (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: modeValue,
            items: _modeItems,
            decoration: const InputDecoration(labelText: 'Jenis'),
            onChanged: onChangedMode,
          ),
        ),
        if (showTypeFilter) ...[
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: typeValue,
              items: _typeItems,
              decoration: const InputDecoration(labelText: 'Kategori'),
              onChanged: onChangedType,
            ),
          ),
        ] else ...[
          // const SizedBox(width: 10),
          // Expanded(
          //   child: DropdownButtonFormField<String>(
          //     value: controller.payment.value,
          //     items: [
          //       ...Constant.dropdownPayment.map(
          //         (e) => DropdownMenuItem<String>(
          //           value: e,
          //           child: Text(e),
          //         ),
          //       ),
          //     ],
          //     decoration: const InputDecoration(
          //       labelText: 'Sumber',
          //     ),
          //     onChanged: (val) {
          //       controller.payment.value = val!;
          //       controller.update();
          //       controller.listData();
          //     },
          //   ),
          // ),
        ],
      ],
    );
  }
}
