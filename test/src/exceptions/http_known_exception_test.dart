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

import 'package:micro_core_http/src/entities/http_request.dart';
import 'package:micro_core_http/src/exceptions/http_known_exception.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpKnownException |',
    () {
      group(
        'Constructor |',
        () {
          const code = 400;
          const reason = 'Bad Request';
          const description = ' description';

          test(
            'The statusCode value should be the code parameter',
            () {
              // Arrange
              const expectedStatusCode = 400;

              // Act
              const exception = HttpKnownException(
                code: code,
                reason: reason,
              );

              // Assert
              expect(exception.statusCode, equals(expectedStatusCode));
            },
          );

          test(
            'The statusMessage value should concatenate the code with the reason parameters',
            () {
              // Arrange
              const expectedStatusMessage = '[ 400 - Bad Request ]';

              // Act
              const exception = HttpKnownException(
                code: code,
                reason: reason,
              );

              // Assert
              expect(exception.statusMessage, equals(expectedStatusMessage));
            },
          );

          test(
            'The statusMessage value should also concatenate the description parameter when passed',
            () {
              // Arrange
              const expectedStatusMessage = '[ 400 - Bad Request ] description';

              // Act
              const exception = HttpKnownException(
                code: code,
                description: description,
                reason: reason,
              );

              // Assert
              expect(exception.statusMessage, equals(expectedStatusMessage));
            },
          );
        },
      );

      group(
        'copyWith() |',
        () {
          const code = 400;
          const reason = 'Bad Request';
          const description = 'description';
          final request = HttpRequest(
            'GET',
            Uri.parse('https://www.jotapetecnologia.com.br'),
          );
          final exception = HttpKnownException(
            code: code,
            description: description,
            reason: reason,
            request: request,
          );

          test(
            'Should be able to replace the code attribute',
            () {
              // Arrange
              const newCode = 400;

              // Act
              final newException = exception.copyWith(code: newCode);

              // Assert
              expect(newException.statusCode, equals(newCode));
            },
          );

          test(
            'Should be able to replace the description attribute',
            () {
              // Arrange
              const newDescription = 'newDescription';

              // Act
              final newException = exception.copyWith(description: newDescription);

              // Assert
              expect(newException.description, equals(newDescription));
            },
          );

          test(
            'Should be able to replace the reason attribute',
            () {
              // Arrange
              const newReason = 'newReason';

              // Act
              final newException = exception.copyWith(reason: newReason);

              // Assert
              expect(newException.reason, equals(newReason));
            },
          );

          test(
            'Should be able to replace the request attribute',
            () {
              // Arrange
              const method = 'POST';
              const url = 'https://api.jotapetecnologia.com.br';
              const segment = 'segment';
              const step = 'step';
              final newRequest = HttpRequest(
                method,
                Uri.parse(url),
                segment: segment,
                step: step,
              );

              // Act
              final newException = exception.copyWith(request: newRequest);

              // Assert
              expect(newException.request?.method, equals(method));
              expect(newException.request?.url.toString(), equals(url));
              expect(newException.request?.segment, equals(segment));
              expect(newException.request?.step, equals(step));
            },
          );
        },
      );

      group(
        'toString() |',
        () {
          const code = 400;
          const reason = 'Bad Request';
          const description = ' description';
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
          const exceptionWithoutRequest = HttpKnownException(
            code: code,
            description: description,
            reason: reason,
          );
          final exceptionWithRequest = HttpKnownException(
            code: code,
            description: description,
            reason: reason,
            request: request,
          );

          test(
            'Should return the log of the exception when the request is null',
            () {
              // Arrange
              const expectedLog = '''
[ HttpKnownException ] > A HttpKnownException was thrown!
[ HttpKnownException ] - Base URL       | null
[ HttpKnownException ] - Endpoint       | null
[ HttpKnownException ] - Query Params   | null
[ HttpKnownException ] - Headers        | null
[ HttpKnownException ] - Segment        | null
[ HttpKnownException ] - Step           | null
[ HttpKnownException ] - Status Code    | 400
[ HttpKnownException ] - Status Message | [ 400 - Bad Request ] description
''';

              // Act
              final exceptionLog = exceptionWithoutRequest.toString();

              // Assert
              expect(exceptionLog, equals(expectedLog));
            },
          );

          test(
            'Should return the log of the exception when the request is not null',
            () {
              // Arrange
              const expectedLog = '''
[ HttpKnownException ] > A HttpKnownException was thrown!
[ HttpKnownException ] - Base URL       | https://api.jotapetecnologia.com.br
[ HttpKnownException ] - Endpoint       | /packages
[ HttpKnownException ] - Query Params   | {}
[ HttpKnownException ] - Headers        | {}
[ HttpKnownException ] - Segment        | segment
[ HttpKnownException ] - Step           | step
[ HttpKnownException ] - Status Code    | 400
[ HttpKnownException ] - Status Message | [ 400 - Bad Request ] description
''';

              // Act
              final exceptionLog = exceptionWithRequest.toString();

              // Assert
              expect(exceptionLog, equals(expectedLog));
            },
          );
        },
      );
    },
  );
}
