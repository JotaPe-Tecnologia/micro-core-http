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
import 'package:micro_core_http/src/clients/http_timeout_client.dart';
import 'package:micro_core_http/src/entities/http_exception.dart';
import 'package:micro_core_http/src/entities/http_request.dart';
import 'package:micro_core_http/src/exceptions/http_exception_request_timeout.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

final class MockClient extends Mock implements http.Client {}

void main() {
  group(
    'HttpTimeoutClient |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should return a http.Client when creating the HttpTimeoutClient',
            () {
              // Arrange
              final inner = http.Client();
              const duration = Duration(seconds: 10);

              // Act
              final timeoutClient = HttpTimeoutClient(inner, duration);

              // Assert
              expect(timeoutClient, isA<HttpTimeoutClient>());
              expect(timeoutClient, isA<http.Client>());
            },
          );
        },
      );

      group(
        'timeoutDefaultMessage |',
        () {
          test(
            'Should return a custom timeout message when the parameter is passed',
            () {
              // Arrange
              final inner = http.Client();
              const duration = Duration(seconds: 10);
              const customMessage = 'customMessage';

              // Act
              final timeoutClient = HttpTimeoutClient(
                inner,
                duration,
                customTimeoutMessage: customMessage,
              );

              // Assert
              expect(timeoutClient.timeoutDefaultMessage, equals(customMessage));
            },
          );

          test(
            'Should return a default timeout message when the parameter is an empty string',
            () {
              // Arrange
              final inner = http.Client();
              const duration = Duration(seconds: 10);
              const customMessage = '';
              final defaultMessage = 'After ${duration.inSeconds} seconds there was no response from the host!';

              // Act
              final timeoutClient = HttpTimeoutClient(
                inner,
                duration,
                customTimeoutMessage: customMessage,
              );

              // Assert
              expect(timeoutClient.timeoutDefaultMessage, equals(defaultMessage));
            },
          );

          test(
            'Should return a default timeout message when the parameter is not passed',
            () {
              // Arrange
              final inner = http.Client();
              const duration = Duration(seconds: 10);
              final defaultMessage = 'After ${duration.inSeconds} seconds there was no response from the host!';

              // Act
              final timeoutClient = HttpTimeoutClient(
                inner,
                duration,
              );

              // Assert
              expect(timeoutClient.timeoutDefaultMessage, equals(defaultMessage));
            },
          );
        },
      );

      group(
        'send() |',
        () {
          const timeoutDuration = Duration(seconds: 2);
          const customTimeoutMessage = 'customTimeoutMessage';
          late final http.Client client;

          setUpAll(() {
            client = MockClient();
          });

          test(
            'Should return a http.StreamedResponse when awaits for the result of send()',
            () async {
              // Arrange
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
              when(
                () => client.send(request),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  Stream.value(Uint8List(5)),
                  200,
                  reasonPhrase: 'OK',
                  request: request,
                ),
              );
              final timeoutClient = HttpTimeoutClient(
                client,
                timeoutDuration,
                customTimeoutMessage: customTimeoutMessage,
              );

              // Act
              final response = await timeoutClient.send(request);

              // Assert
              expect(response, isA<http.StreamedResponse>());
            },
          );

          test(
            'Should throw a HttpExceptionRequestTimeout when the send method takes longer than expected to return',
            () async {
              // Arrange
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
              when(
                () => client.send(request),
              ).thenAnswer((_) async {
                await Future.delayed(const Duration(seconds: 3));
                return http.StreamedResponse(
                  Stream.value(Uint8List(5)),
                  200,
                  reasonPhrase: 'OK',
                  request: request,
                );
              });
              final timeoutClient = HttpTimeoutClient(
                client,
                timeoutDuration,
                customTimeoutMessage: customTimeoutMessage,
              );

              try {
                // Act
                await timeoutClient.send(request);
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionRequestTimeout>());
              }
            },
          );
        },
      );

      group(
        'close() |',
        () {
          test(
            'Should kill the process and close the inner client',
            () {
              // Arrange
              final inner = MockClient();
              const duration = Duration(seconds: 10);
              final timeoutClient = HttpTimeoutClient(
                inner,
                duration,
              );

              // Act
              timeoutClient.close();

              // Assert
              verify(inner.close).called(equals(1));
            },
          );
        },
      );
    },
  );
}
