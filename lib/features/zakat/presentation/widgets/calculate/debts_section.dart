import 'package:flutter/material.dart';
import '../zakat_money_field.dart';
import '../zakat_section_title.dart';

class DebtsSection extends StatelessWidget {
  const DebtsSection({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZakatSectionTitle('ثالثًا: ما عليك من ديون'),
        ZakatMoneyField(
          controller: controller,
          label: 'الديون والالتزامات الحالّة',
          helper: 'أدخل ما حلّ موعد سداده وترى أنه يجوز خصمه.',
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
