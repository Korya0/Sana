import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_result.dart';
import 'package:sana/features/zakat/data/utils/number_utils.dart';

class VerdictCard extends StatelessWidget {
  const VerdictCard({super.key, required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final secondary = theme.colorScheme.secondary;

    late final IconData icon;
    late final String title;
    late final Color bg;
    late final Color fg;

    switch (result.status) {
      case ZakatStatus.due:
        icon = Icons.check_circle_outline;
        title = 'تجب عليك الزكاة';
        bg = primary.withValues(alpha: 0.12);
        fg = primary;
      case ZakatStatus.belowNisab:
        icon = Icons.info_outline;
        title = 'المال لم يبلغ النصاب';
        bg = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
        fg = theme.colorScheme.onSurfaceVariant;
      case ZakatStatus.hawlNotCompleted:
        icon = Icons.hourglass_empty;
        title = 'لم يمر الحول بعد';
        bg = secondary.withValues(alpha: 0.12);
        fg = secondary;
      case ZakatStatus.nisabUnknown:
        icon = Icons.help_outline;
        title = 'سعر المعدن غير مدخل';
        bg = theme.colorScheme.errorContainer.withValues(alpha: 0.3);
        fg = theme.colorScheme.error;
    }

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 54, color: fg),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: fg,
            ),
          ),
          if (result.status == ZakatStatus.due) ...[
            const SizedBox(height: 10),
            Text(
              NumberUtils.formatMoney(result.zakatAmount),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
            const SizedBox(height: 4),
            Text('مقدار الزكاة الواجب إخراجها', style: TextStyle(color: fg)),
          ],
        ],
      ),
    );
  }
}
