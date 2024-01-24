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
import 'package:micro_core_http/src/entities/http_media_type.dart';
import 'package:micro_core_http/src/entities/http_multipart_file.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpMultipartFile |',
    () {
      group(
        'toExternalMultipartFile() |',
        () {
          test(
            'Should return a http.MultipartFile from a HttpMultipartFile',
            () {
              // Arrange
              const field = 'picture';
              final file = HttpMultipartFile(
                Uint8List.fromList(<int>[]),
              );

              // Act
              final result = file.toExternalMultipartFile(field);

              // Assert
              expect(result, isA<http.MultipartFile>());
              expect(result.field, equals(field));
            },
          );
        },
      );

      group(
        'toString() |',
        () {
          final bytes = Uint8List(5);
          final mediaType = HttpMediaType('image', 'png');
          const fileName = 'fileName.png';
          final multipartFile = HttpMultipartFile(
            bytes,
            mediaType: mediaType,
            fileName: fileName,
          );

          test(
            'Should return the log of the multipart file',
            () {
              // Arrange
              const expectedLog = '''
[ HttpMultipartFile ] ----------------------------------------
[ HttpMultipartFile ] - Bytes            | [0, ..., 0]
[ HttpMultipartFile ] - Content Type     | image/png
[ HttpMultipartFile ] - File Name        | fileName.png
[ HttpMultipartFile ] ----------------------------------------
''';

              // Act
              final multipartFileLog = multipartFile.toString();

              // Assert
              expect(multipartFileLog, equals(expectedLog));
            },
          );
        },
      );
    },
  );
}
