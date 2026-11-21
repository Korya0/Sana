import 'package:flutter/material.dart';
import '../zakat_info_card.dart';

class HawlSection extends StatelessWidget {
  const HawlSection({
    super.key,
    required this.hawlCompleted,
    required this.hawlError,
    required this.onHawlChanged,
  });

  final bool hawlCompleted;
  final bool hawlError;
  final ValueChanged<bool?> onHawlChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showError = hawlError && !hawlCompleted;

    return Container(
      decoration: showError
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.error, width: 2),
            )
          : null,
      child: ZakatInfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'مرت سنة هجرية كاملة على مالي وهو بالغ للنصاب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'الحول شرط أساسي في وجوب الزكاة. '
                'لا يمكن عرض نتيجة الحساب إلا بعد التأكد من تمام الحول.',
              ),
              value: hawlCompleted,
              onChanged: onHawlChanged,
            ),
            if (showError) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'يجب التأكد من مرور الحول (سنة هجرية كاملة) لعرض النتيجة.',
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
