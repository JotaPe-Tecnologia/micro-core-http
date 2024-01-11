import 'dart:convert';

import 'package:http/http.dart' as http;

import 'http_multipart_file.dart';
import 'http_multipart_request.dart';

/// Class that represents the data on a [HttpMultipartRequest].
final class HttpFormData {
  /// The data that will be splitted into [fields] and [files] in a [HttpMultipartRequest].
  final Iterable<MapEntry<String, dynamic>> data;

  const HttpFormData(this.data);

  /// Factory that returns a [HttpFormData] from a [Map].
  factory HttpFormData.fromMap(Map<String, dynamic> data) => HttpFormData(data.entries);

  /// Getter of the [HttpMultipartRequest] fields.
  Map<String, String> get fields {
    final fields = <String, String>{};

    // Removing entries where the value is a HttpMultipartFile
    final notMultipartFile = data.where(
      (entry) => entry.value is! HttpMultipartFile,
    );

    // Casting all entries values to String
    final entries = notMultipartFile.map(
      (entry) => MapEntry(entry.key, entry.value.toString()),
    );

    // Adding the entries on the fields Map
    fields.addEntries(entries);

    return fields;
  }

  /// Getter of the [HttpMultipartRequest] files.
  Iterable<http.MultipartFile> get files {
    // Removing entries where the value isn't a HttpMultipartFile
    final onlyMultipartFile = data.where(
      (entry) => entry.value is HttpMultipartFile,
    );

    // Casting all entries values to http.MultipartFile
    final files = onlyMultipartFile.map(
      (entry) => (entry.value as HttpMultipartFile).toExternalMultipartFile(entry.key),
    );

    return files;
  }

  @override
  String toString() {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return '''
[ HttpFormData ] ----------------------------------------
[ HttpFormData ] - Data            | ${data.map(encoder.convert)}
[ HttpFormData ] ----------------------------------------
''';
  }
}
