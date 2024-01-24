// Copyright 2024 JotapeTecnologia

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//     http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'http_media_type.dart';

/// Class that represents some kind of binary data.
final class HttpMultipartFile {
  /// The binary data.
  final Uint8List bytes;

  /// The type of the binary data.
  final HttpMediaType? mediaType;

  /// The name of the file that represents the binary data.
  final String? fileName;

  const HttpMultipartFile(
    this.bytes, {
    this.mediaType,
    this.fileName,
  });

  /// Method that returns a [http.MultipartFile] from a [HttpMultipartFile] and a [field] attribute.
  http.MultipartFile toExternalMultipartFile(String field) {
    return http.MultipartFile.fromBytes(
      field,
      bytes,
      filename: fileName,
      contentType: mediaType,
    );
  }

  @override
  String toString() {
    return '''
[ HttpMultipartFile ] ----------------------------------------
[ HttpMultipartFile ] - Bytes            | [${bytes.first}, ..., ${bytes.last}]
[ HttpMultipartFile ] - Content Type     | ${mediaType.toString()}
[ HttpMultipartFile ] - File Name        | $fileName
[ HttpMultipartFile ] ----------------------------------------
''';
  }
}
