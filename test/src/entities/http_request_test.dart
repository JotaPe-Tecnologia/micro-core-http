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

import 'package:http/http.dart' as http;
import 'package:micro_core_http/src/entities/http_request.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpRequest |',
    () {
      group(
        'fromBaseRequest() |',
        () {
          test(
            'Should return an instance when using factory with a http.BaseRequest',
            () {
              // Arrange
              final baseRequest = http.Request(
                'get', 
                Uri.parse('https://www.jotapetecnologia.com.br'),
              );

              // Act
              final result = HttpRequest.fromBaseRequest(
                baseRequest,
                segment: 'segment',
                step: 'step',
              );

              // Assert
              expect(result, isA<HttpRequest>());
              expect(result.method, equals('GET'));
              expect(result.url.toString(), equals('https://www.jotapetecnologia.com.br'));
              expect(result.segment, equals('segment'));
              expect(result.step, equals('step'));
            },
          );
        },
      );

      group(
        'toString() |',
        () {
          const body = '{"name": "João","age": 25}';
          const headers = {
            'accept': '*/*',
            'content-type': 'application/json',
          };
          const method = 'POST';
          const url = 'https://api.jotapetecnologia.com.br/packages';
          const segment = 'segment';
          const step = 'step';
          final request = HttpRequest(
            method,
            Uri.parse(url),
            segment: segment,
            step: step,
          );
          request.body = body;
          request.headers.addAll(headers);

          test(
            'Should return the log of the request',
            () {
              // Arrange
              const expectedLog = '''
[ HttpRequest ] > A HttpRequest was sent!
[ HttpRequest ] - Method           | POST
[ HttpRequest ] - Base URL         | https://api.jotapetecnologia.com.br
[ HttpRequest ] - Endpoint         | /packages
[ HttpRequest ] - Query Params     | {}
[ HttpRequest ] - Headers          | {
  "content-type": "application/json",
  "accept": "*/*"
}
[ HttpRequest ] - Body             | {
  "name": "João",
  "age": 25
}
[ HttpRequest ] - Segment          | segment
[ HttpRequest ] - Step             | step
[ HttpRequest ] ----------------------------------------
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
