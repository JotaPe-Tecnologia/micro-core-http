import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Class that represents some kind of binary data.
final class HttpMultipartFile {
  /// The binary data.
  final Uint8List bytes;

  /// The type of the binary data.
  ///
  /// [MediaType] is from the [http_parser](https://pub.dev/packages/http_parser) library.
  final MediaType? contentType;

  /// The name of the file that represents the binary data.
  final String? fileName;

  const HttpMultipartFile(
    this.bytes, {
    this.contentType,
    this.fileName,
  });

  /// Method that returns a [http.MultipartFile] from a [HttpMultipartFile] and a [field] attribute.
  http.MultipartFile toExternalMultipartFile(String field) {
    return http.MultipartFile.fromBytes(
      field,
      bytes,
      filename: fileName,
      contentType: contentType,
    );
  }

  @override
  String toString() {
    return '''
[ HttpMultipartFile ] ----------------------------------------
[ HttpMultipartFile ] - Bytes            | [${bytes.first}, ..., ${bytes.last}]
[ HttpMultipartFile ] - Content Type     | ${contentType.toString()}
[ HttpMultipartFile ] - File Name        | $fileName
[ HttpMultipartFile ] ----------------------------------------
''';
  }
}
