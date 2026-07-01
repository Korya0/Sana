import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';
import 'package:sana/features/teaching_prayer/domain/use_cases/parse_teaching_content_use_case.dart';

class ParseTeachingPointsUseCase {
  const ParseTeachingPointsUseCase();

  List<TeachingPointEntity> call(String content) {
    if (content.isEmpty) return [];

    // Regex matches Arabic or Western digits followed by dash
    final pattern = RegExp(r'([\d\u0660-\u0669]+-)');

    // Insert a unique separator before each number pattern
    const separator = '###SPLIT###';
    final formatted = content.replaceAllMapped(pattern, (match) {
      return '$separator${match.group(0)}';
    });

    final parts = formatted.split(separator);
    final points = <TeachingPointEntity>[];
    const parseContent = ParseTeachingContentUseCase();

    // If there is intro text without a number, add it as a general point
    if (parts.isNotEmpty &&
        parts.first.trim().isNotEmpty &&
        !pattern.hasMatch(parts.first.trim())) {
      points.add(TeachingPointEntity(
        number: '',
        spans: parseContent(parts.first.trim()),
      ));
    }

    for (final part in parts) {
      if (part.trim().isEmpty) continue;

      final trimPart = part.trim();
      final match = pattern.firstMatch(trimPart);

      if (match != null && match.start == 0) {
        final number = match.group(0)!;
        final text = trimPart.substring(number.length).trim();
        points.add(TeachingPointEntity(
          number: number,
          spans: parseContent(text),
        ));
      }
    }

    return points;
  }
}
