extension VersionComparison on String {
  /// Compares two full version strings including build number.
  /// Format: 'major.minor.patch+build'  (e.g., '1.0.0+1', '1.1.0+5')
  ///
  /// Logic:
  ///  1. Compare semver part (major.minor.patch) first.
  ///  2. If semver is equal → compare build number.
  // ignore: comment_references
  ///  Returns true if [this] is LESS THAN [latest].
  bool isVersionLessThan(String latest) {
    if (isEmpty || latest.isEmpty) return false;

    try {
      final semverResult = _compareSemver(this, latest);
      if (semverResult != 0) return semverResult < 0;

      // semver is equal → compare build numbers
      final currentBuild = _extractBuild(this);
      final latestBuild = _extractBuild(latest);
      return currentBuild < latestBuild;
    } on Exception catch (_) {
      return false;
    }
  }

  static int _compareSemver(String v1, String v2) {
    final parts1 = v1
        .split('+')[0]
        .split('-')[0]
        .split('.')
        .map(int.parse)
        .toList();
    final parts2 = v2
        .split('+')[0]
        .split('-')[0]
        .split('.')
        .map(int.parse)
        .toList();

    final maxLen = parts1.length > parts2.length
        ? parts1.length
        : parts2.length;
    for (var i = 0; i < maxLen; i++) {
      final p1 = i < parts1.length ? parts1[i] : 0;
      final p2 = i < parts2.length ? parts2[i] : 0;
      if (p1 < p2) return -1;
      if (p1 > p2) return 1;
    }
    return 0;
  }

  static int _extractBuild(String version) {
    final parts = version.split('+');
    if (parts.length < 2) return 0;
    return int.tryParse(parts[1].split('-')[0]) ?? 0;
  }
}
