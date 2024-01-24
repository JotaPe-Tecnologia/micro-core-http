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
import 'package:micro_core_http/src/entities/http_form_data.dart';
import 'package:micro_core_http/src/entities/http_media_type.dart';
import 'package:micro_core_http/src/entities/http_multipart_file.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpFormData |',
    () {
      final data = {
        'name': 'João',
        'age': 25,
        'picture': HttpMultipartFile(Uint8List.fromList(<int>[])),
      };

      group(
        'fromMap() |',
        () {
          test(
            'Should return an instance when using factory with a Map',
            () {
              // Arrange
              const expectedLength = 3;

              // Act
              final result = HttpFormData.fromMap(data);

              // Assert
              expect(result, isA<HttpFormData>());
              expect(result.data.length, equals(expectedLength));
            },
          );
        },
      );

      group(
        'fields |',
        () {
          test(
            'Should return a Map<String, String> with all the data that is not a file',
            () {
              // Arrange
              const expectedLength = 2;
              final formData = HttpFormData.fromMap(data);

              // Act
              final fields = formData.fields;

              // Assert
              expect(fields, isA<Map<String, String>>());
              expect(fields.length, equals(expectedLength));
              expect(fields.containsKey('picture'), isFalse);
            },
          );
        },
      );

      group(
        'files |',
        () {
          test(
            'Should return a Iterable<http.MultipartFile> with all the data that is a file',
            () {
              // Arrange
              const expectedLength = 1;
              final formData = HttpFormData.fromMap(data);

              // Act
              final files = formData.files;

              // Assert
              expect(files, isA<Iterable<http.MultipartFile>>());
              expect(files.length, equals(expectedLength));
              expect(files.first.field, equals('picture'));
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
          final emptyData = <String, dynamic>{};
          final filledData = {
            "name": "João",
            "age": 25,
            "picture": multipartFile,
          };
          final emptyFormData = HttpFormData.fromMap(emptyData);
          final filledFormData = HttpFormData.fromMap(filledData);

          test(
            'Should return the log of the form data with an empty data',
            () {
              // Arrange
              const expectedLog = '''
[ HttpFormData ] ----------------------------------------
[ HttpFormData ] - Data            | {}
[ HttpFormData ] ----------------------------------------
''';

              // Act
              final formDataLog = emptyFormData.toString();

              // Assert
              expect(formDataLog, equals(expectedLog));
            },
          );

          test(
            'Should return the log of the form data with data',
            () {
              // Arrange
              const expectedLog = '''
[ HttpFormData ] ----------------------------------------
[ HttpFormData ] - Data            | {
  "name": "João",
  "age": 25,
  "picture": "fileName.png"
}
[ HttpFormData ] ----------------------------------------
''';

              // Act
              final formDataLog = filledFormData.toString();

              // Assert
              expect(formDataLog, equals(expectedLog));
            },
          );
        },
      );
    },
  );
}
