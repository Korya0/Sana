class HadithFormatter {
  HadithFormatter._();

  static String formatForCopy(String htmlContent) {
    final text = htmlContent
        .replaceAll(RegExp('<div class="divider">.*?</div>'), '\n---\n')
        .replaceAll(RegExp('</div>'), '\n')
        .replaceAll(RegExp('<[^>]*>'), '')
        .trim();

    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty || e == '---')
        .join('\n');
  }

  static RegExp? createHighlightRegex(String? searchQuery) {
    if (searchQuery == null || searchQuery.trim().isEmpty) return null;

    final query = searchQuery.trim();
    // Diacritics matching regex
    const diacritics = r'[\u064B-\u0652]*';
    final regexPattern = query
        .split('')
        .map((char) => char + diacritics)
        .join();
    return RegExp(regexPattern, caseSensitive: false);
  }

  static String highlightSearchQuery(String content, RegExp? regex) {
    if (regex == null) return content;

    return content.splitMapJoin(
      RegExp('<[^>]*>'),
      onMatch: (m) => m.group(0)!,
      onNonMatch: (text) {
        return text.replaceAllMapped(regex, (match) {
          return '<span class="highlight">${match.group(0)}</span>';
        });
      },
    );
  }
}
