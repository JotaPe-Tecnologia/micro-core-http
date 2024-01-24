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
import 'package:micro_core_http/src/entities/http_response.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpResponse |',
    () {
      group(
        'fromResponse() |',
        () {
          test(
            'Should return an instance when using factory with a http.Response',
            () {
              // Arrange
              final response = http.Response(
                '{"name": "João", "age": 25}',
                200,
                request: http.Request(
                  'GET',
                  Uri.parse('https://www.jotapetecnologia.com.br'),
                ),
                headers: {
                  'accept': '*/*',
                  'content-type': 'application/json',
                },
                reasonPhrase: 'OK',
              );

              // Act
              final result = HttpResponse.fromResponse(
                response,
                segment: 'segment',
                step: 'step',
              );

              // Assert
              expect(result, isA<HttpResponse>());
              expect(result.data, isA<Map<String, dynamic>>());
              expect(result.data['name'], equals('João'));
              expect(result.headers, isA<Map<String, String>>());
              expect(result.headers['content-type'], equals('application/json'));
              expect(result.isRedirect, isFalse);
              expect(result.persistentConnection, isTrue);
              expect(result.request?.method, equals('GET'));
              expect(result.request?.url.toString(), equals('https://www.jotapetecnologia.com.br'));
              expect(result.segment, equals('segment'));
              expect(result.statusCode, equals(200));
              expect(result.statusMessage, equals('OK'));
              expect(result.step, equals('step'));
            },
          );
        },
      );

      group(
        'toString() |',
        () {
          const data = {
            'name': 'João',
            'age': 25,
          };
          const headers = {
            'accept': '*/*',
            'content-type': 'application/json',
          };
          const statusCode = 200;
          const statusMessage = 'OK';
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
          final responseWithoutRequest = HttpResponse(
            data: data,
            headers: headers,
            segment: segment,
            statusCode: statusCode,
            statusMessage: statusMessage,
            step: step,
          );
          final responseWithRequest = HttpResponse(
            data: data,
            headers: headers,
            request: request,
            segment: segment,
            statusCode: statusCode,
            statusMessage: statusMessage,
            step: step,
          );

          test(
            'Should return the log of the response when the request is null',
            () {
              // Arrange
              const expectedLog = '''
[ HttpResponse ] > A HttpResponse was received!
[ HttpResponse ] - Method          | null
[ HttpResponse ] - Base URL        | null
[ HttpResponse ] - Endpoint        | null
[ HttpResponse ] - Status Code     | 200
[ HttpResponse ] - Status Message  | OK
[ HttpResponse ] - Headers         | {
  "accept": "*/*",
  "content-type": "application/json"
}
[ HttpResponse ] - Data            | {
  "name": "João",
  "age": 25
}
[ HttpResponse ] - Segment         | segment
[ HttpResponse ] - Step            | step
[ HttpResponse ] -----------------------------------------
''';

              // Act
              final responseLog = responseWithoutRequest.toString();

              // Assert
              expect(responseLog, equals(expectedLog));
            },
          );

          test(
            'Should return the log of the response when the request is not null',
            () {
              // Arrange
              const expectedLog = '''
[ HttpResponse ] > A HttpResponse was received!
[ HttpResponse ] - Method          | POST
[ HttpResponse ] - Base URL        | https://api.jotapetecnologia.com.br
[ HttpResponse ] - Endpoint        | /packages
[ HttpResponse ] - Status Code     | 200
[ HttpResponse ] - Status Message  | OK
[ HttpResponse ] - Headers         | {
  "accept": "*/*",
  "content-type": "application/json"
}
[ HttpResponse ] - Data            | {
  "name": "João",
  "age": 25
}
[ HttpResponse ] - Segment         | segment
[ HttpResponse ] - Step            | step
[ HttpResponse ] -----------------------------------------
''';

              // Act
              final responseLog = responseWithRequest.toString();

              // Assert
              expect(responseLog, equals(expectedLog));
            },
          );
        },
      );
    },
  );
}
