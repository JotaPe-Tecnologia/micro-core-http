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
import 'package:micro_core_http/src/entities/http_multipart_request.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpRequest |',
    () {
      group(
        'toString() |',
        () {
          const body = {
            "name": "João",
            "age": "25",
          };
          const headers = {
            'accept': '*/*',
            'content-type': 'application/json',
          };
          const method = 'POST';
          const url = 'https://api.jotapetecnologia.com.br/packages';
          const segment = 'segment';
          const step = 'step';
          final request = HttpMultipartRequest(
            method,
            Uri.parse(url),
            segment: segment,
            step: step,
          );
          request.fields.addAll(body);
          request.files.addAll([
            http.MultipartFile.fromBytes(
              'picture',
              Uint8List(5),
            ),
          ]);
          request.headers.addAll(headers);

          test(
            'Should return the log of the multipart request',
            () {
              // Arrange
              const expectedLog = '''
[ HttpMultipartRequest ] > A HttpMultipartRequest was sent!
[ HttpMultipartRequest ] - Method           | POST
[ HttpMultipartRequest ] - Base URL         | https://api.jotapetecnologia.com.br
[ HttpMultipartRequest ] - Endpoint         | /packages
[ HttpMultipartRequest ] - Query Params     | {}
[ HttpMultipartRequest ] - Headers          | {
  "accept": "*/*",
  "content-type": "application/json"
}
[ HttpMultipartRequest ] - Body             | {
  "name": "João",
  "age": "25"
}
[ HttpMultipartRequest ] - Files            | [Instance of 'MultipartFile']
[ HttpMultipartRequest ] - Segment          | segment
[ HttpMultipartRequest ] - Step             | step
[ HttpMultipartRequest ] ----------------------------------------
''';

              // Act
              final requestLog = request.toString();

              // Assert
              expect(requestLog, equals(expectedLog));
            },
          );
        },
      );
    },
  );
}
