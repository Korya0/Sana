class TeachingPointModel {
  TeachingPointModel({required this.number, required this.text});
  final String number;
  final String text;
}

class TeachingContentParser {
  TeachingContentParser._();

  static List<TeachingPointModel> parseContent(String content) {
    // Regex matches Arabic or Western digits followed by dash
    final pattern = RegExp(r'([\d\u0660-\u0669]+-)');

    // Insert a unique separator before each number pattern
    const separator = '###SPLIT###';
    final formatted = content.replaceAllMapped(pattern, (match) {
      return '$separator${match.group(0)}';
    });

    final parts = formatted.split(separator);
    final points = <TeachingPointModel>[];

    // If there is intro text without a number, add it as a general point
    if (parts.isNotEmpty &&
        parts.first.trim().isNotEmpty &&
        !pattern.hasMatch(parts.first.trim())) {
      points.add(TeachingPointModel(number: '', text: parts.first.trim()));
    }

    for (final part in parts) {
      if (part.trim().isEmpty) continue;

      final trimPart = part.trim();
      final match = pattern.firstMatch(trimPart);

      if (match != null && match.start == 0) {
        final number = match.group(0)!;
        final text = trimPart.substring(number.length).trim();
        points.add(TeachingPointModel(number: number, text: text));
      }
    }

    return points;
  }
}
