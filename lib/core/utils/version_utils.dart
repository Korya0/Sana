class VersionUtils {
  const VersionUtils._();

  /// Compares two version strings (e.g., '1.0.0' and '1.0.1')
  /// Returns true if [current] is less than [latest].
  static bool isVersionLessThan(String current, String latest) {
    if (current == '0.0.0' || latest.isEmpty) return false;

    try {
      // Remove build number (+1) and suffixes (-alpha)
      final cleanCurrent = current.split('+')[0].split('-')[0];
      final cleanLatest = latest.split('+')[0].split('-')[0];

      final v1 = cleanCurrent.split('.').map(int.parse).toList();
      final v2 = cleanLatest.split('.').map(int.parse).toList();

      for (var i = 0; i < v1.length && i < v2.length; i++) {
        if (v1[i] < v2[i]) return true;
        if (v1[i] > v2[i]) return false;
      }
      return v2.length > v1.length;
    } catch (_) {
      return false; // Safely return false if version format is invalid
    }
  }
}
