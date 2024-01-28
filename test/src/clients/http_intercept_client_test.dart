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
import 'package:micro_core_http/src/clients/http_intercept_client.dart';
import 'package:micro_core_http/src/defaults/default_http_request_handler.dart';
import 'package:micro_core_http/src/entities/http_streamed_response.dart';
import 'package:micro_core_http/src/micro_core_http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

final class MockClient extends Mock implements http.Client {}

final class MockInterceptClient extends Mock implements HttpInterceptClient {}

final class MockHttpRequestHandler extends Mock implements IHttpRequestHandler {}

void main() {
  group(
    'HttpInterceptClient |',
    () {
      setUp(
        () {
          registerFallbackValue(
            HttpRequest(
              'GET',
              Uri.parse('https://api.jotapetecnologia.com.br/packages'),
            ),
          );
        },
      );

      group(
        'Extension |',
        () {
          test(
            'Should return a http.Client when creating the HttpInterceptClient',
            () {
              // Arrange
              final inner = http.Client();
              const requestHandler = DefaultHttpRequestHandler();

              // Act
              final interceptClient = HttpInterceptClient(
                inner,
                requestHandler,
              );

              // Assert
              expect(interceptClient, isA<HttpInterceptClient>());
              expect(interceptClient, isA<http.Client>());
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
              final interceptClient = HttpInterceptClient(inner, const DefaultHttpRequestHandler());

              // Act
              interceptClient.close();

              // Assert
              verify(inner.close).called(equals(1));
            },
          );
        },
      );

      group(
        'createRequest() |',
        () {
          late final http.Client inner;
          late final IHttpRequestHandler requestHandler;
          late final HttpInterceptClient client;

          setUpAll(
            () {
              inner = MockClient();
              requestHandler = MockHttpRequestHandler();
              client = HttpInterceptClient(
                inner,
                requestHandler,
                showLogs: true,
              );
            },
          );

          test(
            'Should create a HttpMultipartRequest when the body is a HttpFormData',
            () {
              // Arrange
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final body = HttpFormData.fromMap({
                "name": "João",
                "age": 25,
                "picture": HttpMultipartFile(
                  Uint8List(5),
                  mediaType: HttpMediaType('image', 'png'),
                  fileName: 'fileName.png',
                ),
              });
              const expectedHeaders = {"accept": "*/*", "content-type": "multipart/form-data"};

              // Act
              final request = client.createRequest(
                method,
                uri,
                body: body,
              );

              // Assert
              expect(request, isA<HttpMultipartRequest>());
              expect(request.headers, equals(expectedHeaders));
            },
          );

          test(
            'Should create a HttpRequest when the body is not a HttpFormData',
            () {
              // Arrange
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              const body = {"name": "João", "age": 25};
              const expectedHeaders = {"accept": "*/*", "content-type": "application/json; charset=utf-8"};

              // Act
              final request = client.createRequest(
                method,
                uri,
                body: body,
              );

              // Assert
              expect(request, isA<HttpRequest>());
              expect(request.headers, equals(expectedHeaders));
            },
          );

          test(
            'Should throw an ArgumentError when the body is not String, List or Map',
            () {
              // Arrange
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              const body = 25;
              const expectedErrorMessage = '[ ArgumentError ] > Invalid Request Body "25".';

              try {
                // Act
                final _ = client.createRequest(
                  method,
                  uri,
                  body: body,
                );
              } on ArgumentError catch (error) {
                // Assert
                expect(error.message, equals(expectedErrorMessage));
              }
            },
          );

          test(
            'Should add headers on the headers of the request',
            () {
              // Arrange
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              const body = {"name": "João", "age": 25};
              const headers = {"Authorization": "Bearer Token"};
              const expectedHeaders = {
                "accept": "*/*",
                "content-type": "application/json; charset=utf-8",
                "Authorization": "Bearer Token",
              };

              // Act
              final request = client.createRequest(
                method,
                uri,
                body: body,
                headers: headers,
              );

              // Assert
              expect(request.headers, equals(expectedHeaders));
            },
          );
        },
      );

      group(
        'send() |',
        () {
          late final http.Client inner;
          late final IHttpRequestHandler requestHandler;
          late final HttpInterceptClient client;

          setUpAll(
            () {
              inner = MockClient();
              requestHandler = MockHttpRequestHandler();
              client = HttpInterceptClient(
                inner,
                requestHandler,
                showLogs: true,
              );
            },
          );

          test(
            'Should call the send method of inner client',
            () {
              // Arrange
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              client.send(request);

              // Assert
              verify(() => inner.send(request)).called(equals(1));
            },
          );
        },
      );

      group(
        'sendUnstreamed() |',
        () {
          late final http.Client inner;
          late final IHttpRequestHandler requestHandler;
          HttpInterceptClient? client;

          setUpAll(
            () {
              inner = MockClient();
              requestHandler = MockHttpRequestHandler();
            },
          );

          test(
            'Should call the requestHandler logRequest method when showLogs is true',
            () {
              // Arrange
              client = HttpInterceptClient(
                inner,
                requestHandler,
                showLogs: true,
              );
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              client?.sendUnstreamed(request);

              // Assert
              verify(() => requestHandler.logRequest(request)).called(equals(1));
            },
          );

          test(
            'Should call the requestHandler onRequest method',
            () {
              // Arrange
              client = HttpInterceptClient(
                inner,
                requestHandler,
              );
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              client?.sendUnstreamed(request);

              // Assert
              verify(() => requestHandler.onRequest(request)).called(equals(1));
            },
          );

          test(
            'Should not call the requestHandler logRequest method when showLogs is false',
            () {
              // Arrange
              client = HttpInterceptClient(
                inner,
                requestHandler,
              );
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              client?.sendUnstreamed(request);

              // Assert
              verifyNever(() => requestHandler.logRequest(request));
            },
          );

          test(
            'Should call the inner.send() method',
            () {
              // Arrange
              client = HttpInterceptClient(
                inner,
                requestHandler,
                showLogs: true,
              );
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              client?.sendUnstreamed(request);

              // Assert
              verify(() => inner.send(request)).called(equals(1));
            },
          );

          test(
            'Should return a http.Response',
            () async {
              // Arrange
              client = HttpInterceptClient(
                inner,
                requestHandler,
                showLogs: true,
              );
              const segment = 'segment';
              const step = 'step';
              const statusCode = 200;
              final stream = Stream.value(<int>[]);
              const method = 'POST';
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              final request = HttpRequest(method, uri, segment: segment, step: step);
              when(() => inner.send(request)).thenAnswer(
                (_) async => HttpStreamedResponse(
                  stream,
                  statusCode,
                  reasonPhrase: 'OK',
                  request: request,
                ),
              );

              // Act
              final response = await client?.sendUnstreamed(request);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'delete() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.delete(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'get() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.get(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'head() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.head(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'patch() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.patch(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'post() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.post(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );

      group(
        'put() |',
        () {
          test(
            'Should return a http.Response',
            () async {
              // Arrange
              final inner = MockClient();
              final client = HttpInterceptClient(
                inner,
                const DefaultHttpRequestHandler(),
              );
              final stream = Stream.value(<int>[]);
              const statusCode = 200;
              final uri = Uri.parse('https://api.jotapetecnologia.com.br/packages');
              when(
                () => inner.send(any()),
              ).thenAnswer(
                (_) async => http.StreamedResponse(
                  stream,
                  statusCode,
                ),
              );

              // Act
              final response = await client.put(uri);

              // Assert
              expect(response, isA<http.Response>());
            },
          );
        },
      );
    },
  );
}
