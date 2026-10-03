import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Whole-number UGX input. Reports 0 when the field is empty.
class MoneyField extends StatelessWidget {
  const MoneyField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: appInput(label, prefixText: 'UGX '),
      onChanged: (value) => onChanged?.call(int.tryParse(value) ?? 0),
    );
  }
}
