abstract class UriUtils {
  /// Creates a new URI from baseUrl, endpoint and query parameters.
  ///
  /// https://api.dart.dev/stable/2.19.2/dart-core/Uri/Uri.html
  ///
  /// Can throw a [FormatException] if "$baseUrl$endpoint" is not a valid URL.
  ///
  /// Example:
  /// ```dart
  /// var uri = getUri('https://domain.com', '/path', {'page': 0});
  /// print(uri); // https://domain.com/path?page=0
  /// ```
  static Uri generateUri(
    String baseUrl, {
    String endpoint = '', 
    Map<String, dynamic>? queryParameters,
  }) {
    //  [...] A value in the map must be either null, a string, or an Iterable
    // of strings. An iterable corresponds to multiple values for the same key,
    // and an empty iterable or null corresponds to no value for the key. [...]
    queryParameters = queryParameters?.map((k, v) {
      if (v == null) return MapEntry(k, v);
      if (v == Iterable<String>) return MapEntry(k, v);
      return MapEntry(k, v.toString());
    });

    // Creating a Uri with https scheme
    if (baseUrl.startsWith('https://')) {
      return Uri.https(
        baseUrl.replaceFirst('https://', ''),
        endpoint,
        queryParameters,
      );
    }

    // Creating a Uri with http scheme
    if (baseUrl.startsWith('https://')) {
      return Uri.http(
        baseUrl.replaceFirst('http://', ''),
        endpoint,
        queryParameters,
      );
    }

    // Creating a Uri with a custom scheme
    return Uri.parse('$baseUrl$endpoint');
  }
}