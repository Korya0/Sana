/// Abstraction for launching URLs.
/// Allows views to open external links without depending on url_launcher directly.
abstract interface class LaunchUrlService {
  /// Opens the given URL in an external application (browser, etc.).
  Future<bool> launch(String url);
}
