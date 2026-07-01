import 'package:sana/features/teaching_prayer/domain/entities/teaching_prayer_entity.dart';

class ParseTeachingContentUseCase {
  const ParseTeachingContentUseCase();

  List<HighlightedSpanEntity> call(String content) {
    if (content.isEmpty) return [];

    final spans = <HighlightedSpanEntity>[];
    final regex = RegExp(r'\((.*?)\)');
    var lastMatchEnd = 0;

    for (final match in regex.allMatches(content)) {
      final prefix = content.substring(lastMatchEnd, match.start);
      if (prefix.isNotEmpty) {
        spans.add(HighlightedSpanEntity(text: prefix, isHighlighted: false));
      }
      // Add the matched text (with parentheses)
      spans.add(HighlightedSpanEntity(text: match.group(0)!, isHighlighted: true));
      lastMatchEnd = match.end;
    }

    final suffix = content.substring(lastMatchEnd);
    if (suffix.isNotEmpty) {
      spans.add(HighlightedSpanEntity(text: suffix, isHighlighted: false));
    }

    return spans;
  }
}
