import 'package:flutter/material.dart';
import 'package:sana/features/zakat/data/models/zakat_input.dart';

class NisabStandardSelector extends StatelessWidget {
  const NisabStandardSelector({
    super.key,
    required this.standard,
    required this.onStandardChanged,
    required this.goldKarat,
    required this.onKaratChanged,
  });

  final NisabStandard standard;
  final ValueChanged<NisabStandard> onStandardChanged;
  final int goldKarat;
  final ValueChanged<int?> onKaratChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر المعيار الذي تعتمده في تقدير النصاب:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<NisabStandard>(
            segments: [
              for (final s in NisabStandard.values)
                ButtonSegment(value: s, label: Text('نصاب ${s.label}')),
            ],
            selected: {standard},
            onSelectionChanged: (s) => onStandardChanged(s.first),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          key: ValueKey('gold_karat_$goldKarat'),
          initialValue: goldKarat,
          decoration: const InputDecoration(
            labelText: 'عيار الذهب',
            helperText: 'اختر عيار الذهب الذي تملكه. الشائع في مصر عيار 21.',
          ),
          items: [
            for (final karat in GoldKarats.common)
              DropdownMenuItem(value: karat, child: Text('عيار $karat')),
          ],
          onChanged: onKaratChanged,
        ),
      ],
    );
  }
}
