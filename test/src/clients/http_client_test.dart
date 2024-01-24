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
import 'package:micro_core_http/src/clients/http_client.dart';
import 'package:micro_core_http/src/clients/http_intercept_client.dart';
import 'package:micro_core_http/src/entities/http_exception.dart';
import 'package:micro_core_http/src/entities/http_options.dart';
import 'package:micro_core_http/src/entities/http_response.dart';
import 'package:micro_core_http/src/entities/http_streamed_response.dart';
import 'package:micro_core_http/src/exceptions/http_exception_bad_request.dart';
import 'package:micro_core_http/src/exceptions/http_exception_unauthorized.dart';
import 'package:micro_core_http/src/interfaces/http_client_interface.dart';
import 'package:micro_core_http/src/interfaces/http_error_handler_interface.dart';
import 'package:micro_core_http/src/interfaces/http_exception_handler_interface.dart';
import 'package:micro_core_http/src/interfaces/http_refresh_handler_interface.dart';
import 'package:micro_core_http/src/utils/constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

final class MockClient extends Mock implements http.Client {}

final class MockErrorHandler extends Mock implements IHttpErrorHandler {}

final class MockExceptionHandler extends Mock implements IHttpExceptionHandler {}

final class MockRefreshHandler extends Mock implements IHttpRefreshHandler {}

void main() {
  const baseUrl = 'https://api.jotapetecnologia.com.br';

  group(
    'HttpClient |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be an extension of IHttpClient',
            () {
              // Arrange
              final options = HttpOptions(baseUrl: baseUrl);

              // Act
              final client = HttpClient(options: options);

              // Assert
              expect(client, isA<IHttpClient>());
            },
          );
        },
      );

      group(
        'handleError() |',
        () {
          late final IHttpErrorHandler errorHandler;

          setUpAll(() {
            errorHandler = MockErrorHandler();
          });

          setUp(() {
            registerFallbackValue(ArgumentError());
            registerFallbackValue(StackTrace.current);
          });

          tearDown(() {
            resetMocktailState();
          });

          test(
            'Should call the IHttpErrorHandler.onError callback when catch an Error',
            () async {
              // Arrange
              when(() => errorHandler.onError(any(), any()));
              final options = HttpOptions(baseUrl: baseUrl, errorHandler: errorHandler);
              final client = HttpClient(options: options);

              // Act
              client.handleError(ArgumentError(), StackTrace.current);

              // Assert
              verify(() => errorHandler.onError(any(), any())).called(equals(1));
            },
          );

          test(
            'Should call the IHttpErrorHandler.logError callback when catch an Error and HttpOptions.showLogs is true',
            () async {
              // Arrange
              when(() => errorHandler.logError(any(), any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                errorHandler: errorHandler,
                showLogs: true,
              );
              final client = HttpClient(options: options);

              // Act
              client.handleError(ArgumentError(), StackTrace.current);

              // Assert
              verify(() => errorHandler.logError(any(), any())).called(equals(1));
            },
          );

          test(
            'Should not call the IHttpErrorHandler.logError callback when catch an Error and HttpOptions.showLogs is false',
            () async {
              // Arrange
              when(() => errorHandler.logError(any(), any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                errorHandler: errorHandler,
                showLogs: false,
              );
              final client = HttpClient(options: options);

              // Act
              client.handleError(ArgumentError(), StackTrace.current);

              // Assert
              verifyNever(() => errorHandler.logError(any(), any()));
            },
          );
        },
      );

      group(
        'handleException() |',
        () {
          late final IHttpExceptionHandler exceptionHandler;
          late final IHttpRefreshHandler refreshHandler;

          Future<HttpResponse> request() async {
            throw UnimplementedError();
          }

          setUpAll(() {
            exceptionHandler = MockExceptionHandler();
            refreshHandler = MockRefreshHandler();
          });

          setUp(() {
            registerFallbackValue(HttpExceptionUnauthorized());
            registerFallbackValue(StackTrace.current);
            registerFallbackValue(request);
          });

          tearDown(() {
            resetMocktailState();
          });

          test(
            'Should call the IHttpExceptionHandler.onException callback when catch an Exception',
            () async {
              // Arrange
              when(() => exceptionHandler.onException(any(), any()));
              final options = HttpOptions(baseUrl: baseUrl, exceptionHandler: exceptionHandler);
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionBadRequest(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (_) {
                // Assert
                verify(() => exceptionHandler.onException(any(), any())).called(equals(1));
              }
            },
          );

          test(
            'Should call the IHttpExceptionHandler.logException callback when catch an Exception and HttpOptions.showLogs is true',
            () async {
              // Arrange
              when(() => exceptionHandler.logException(any(), any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                showLogs: true,
              );
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionBadRequest(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (_) {
                // Assert
                verify(() => exceptionHandler.logException(any(), any())).called(equals(1));
              }
            },
          );

          test(
            'Should not call the IHttpExceptionHandler.logException callback when catch an Exception and HttpOptions.showLogs is false',
            () async {
              // Arrange
              when(() => exceptionHandler.logException(any(), any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                showLogs: false,
              );
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionBadRequest(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (_) {
                // Assert
                verifyNever(() => exceptionHandler.logException(any(), any()));
              }
            },
          );

          test(
            'Should call the IHttpRefreshHandler.refreshTokenAndRetryRequest callback when catch an Exception with the right statusCode and HttpOptions.refreshTokenAndRetryRequest is true',
            () async {
              // Arrange
              when(
                () => refreshHandler.statusCode(),
              ).thenReturn(401);
              when(
                () => refreshHandler.refreshTokenAndRetryRequest(any()),
              ).thenAnswer((_) async => HttpResponse(data: [], headers: {}, statusCode: 200));
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                refreshHandler: refreshHandler,
                refreshTokenAndRetryRequest: true,
              );
              final client = HttpClient(options: options);

              // Act
              client.handleException(
                HttpExceptionUnauthorized(),
                StackTrace.current,
                request,
              );

              // Assert
              verify(() => refreshHandler.refreshTokenAndRetryRequest(any())).called(equals(1));
            },
          );

          test(
            'Should not call the IHttpRefreshHandler.refreshTokenAndRetryRequest callback when catch an Exception with the wrong statusCode and HttpOptions.refreshTokenAndRetryRequest is true',
            () async {
              // Arrange
              when(
                () => refreshHandler.statusCode(),
              ).thenReturn(401);
              when(
                () => refreshHandler.refreshTokenAndRetryRequest(any()),
              );
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                refreshHandler: refreshHandler,
                refreshTokenAndRetryRequest: true,
              );
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionBadRequest(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (_) {
                // Assert
                verifyNever(() => refreshHandler.refreshTokenAndRetryRequest(any()));
              }
            },
          );

          test(
            'Should not call the IHttpRefreshHandler.refreshTokenAndRetryRequest callback when catch an Exception with the right statusCode and HttpOptions.refreshTokenAndRetryRequest is false',
            () async {
              // Arrange
              when(
                () => refreshHandler.statusCode(),
              ).thenReturn(401);
              when(
                () => refreshHandler.refreshTokenAndRetryRequest(any()),
              );
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                refreshHandler: refreshHandler,
                refreshTokenAndRetryRequest: false,
              );
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionUnauthorized(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (_) {
                // Assert
                verifyNever(() => refreshHandler.refreshTokenAndRetryRequest(any()));
              }
            },
          );

          test(
            'Should return a HttpResponse when IHttpRefreshHandler.refreshTokenAndRetryRequest callback runs with success',
            () async {
              // Arrange
              when(
                () => refreshHandler.statusCode(),
              ).thenReturn(401);
              when(
                () => refreshHandler.refreshTokenAndRetryRequest(any()),
              ).thenAnswer((_) async => HttpResponse(data: [], headers: {}, statusCode: 200));
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                refreshHandler: refreshHandler,
                refreshTokenAndRetryRequest: true,
              );
              final client = HttpClient(options: options);

              // Act
              final response = await client.handleException(
                HttpExceptionUnauthorized(),
                StackTrace.current,
                request,
              );

              // Assert
              expect(response.statusCode, equals(200));
            },
          );

          test(
            'Should throw an HttpException when IHttpRefreshHandler.refreshTokenAndRetryRequest callback runs with failure',
            () async {
              // Arrange
              when(
                () => refreshHandler.statusCode(),
              ).thenReturn(401);
              when(
                () => refreshHandler.refreshTokenAndRetryRequest(any()),
              ).thenThrow(HttpExceptionBadRequest());
              final options = HttpOptions(
                baseUrl: baseUrl,
                exceptionHandler: exceptionHandler,
                refreshHandler: refreshHandler,
                refreshTokenAndRetryRequest: true,
              );
              final client = HttpClient(options: options);

              try {
                // Act
                await client.handleException(
                  HttpExceptionUnauthorized(),
                  StackTrace.current,
                  request,
                );
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
              }
            },
          );
        },
      );

      group(
        'sendRequest() |',
        () {
          late final http.Client customClient;
          late final IHttpErrorHandler errorHandler;
          late final IHttpExceptionHandler exceptionHandler;

          setUpAll(() {
            customClient = MockClient();
            errorHandler = MockErrorHandler();
            exceptionHandler = MockExceptionHandler();
          });

          setUp(() {
            registerFallbackValue(HttpExceptionUnauthorized());
            registerFallbackValue(TypeError());
            registerFallbackValue(StackTrace.current);
            registerFallbackValue(
              http.Request('GET', Uri.parse('$baseUrl/endpoint')),
            );
          });

          tearDown(() {
            reset(customClient);
            reset(errorHandler);
            reset(exceptionHandler);
            resetMocktailState();
          });

          test(
            'Should return a HttpResponse when gets a successfull response',
            () async {
              // Arrange
              const statusCode = 200;
              const expectedData = {"name": "João"};
              const data = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              when(() => customClient.send(any())).thenAnswer(
                (_) async => HttpStreamedResponse(Stream.value(data), statusCode),
              );
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.sendRequest((client) async {
                final httpResponse = await client.get(Uri.parse('$baseUrl/endpoint'));
                return HttpResponse.fromResponse(httpResponse);
              });

              // Assert
              expect(response.statusCode, equals(statusCode));
              expect(response.data, equals(expectedData));
              verify(() => customClient.send(any())).called(1);
            },
          );

          test(
            'Should close the client when gets a response',
            () async {
              // Arrange
              const statusCode = 200;
              const data = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              when(() => customClient.send(any())).thenAnswer(
                (_) async => HttpStreamedResponse(Stream.value(data), statusCode),
              );
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.sendRequest((client) async {
                final httpResponse = await client.get(Uri.parse('$baseUrl/endpoint'));
                return HttpResponse.fromResponse(httpResponse);
              });

              // Assert
              verify(() => customClient.close()).called(1);
            },
          );

          test(
            'Should close the client when an exception is thrown',
            () async {
              // Arrange
              when(() => customClient.send(any())).thenThrow(HttpExceptionBadRequest());
              final options = HttpOptions(baseUrl: baseUrl, exceptionHandler: exceptionHandler);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.sendRequest((client) async {
                  final httpResponse = await client.get(Uri.parse('$baseUrl/endpoint'));
                  return HttpResponse.fromResponse(httpResponse);
                });
              } on HttpException catch (_) {
                // Assert
                verify(() => customClient.close()).called(1);
              }
            },
          );

          test(
            'Should call the handleError method when catch an Error and then rethrow',
            () async {
              // Arrange
              when(() => customClient.send(any())).thenThrow(TypeError());
              final options = HttpOptions(baseUrl: baseUrl, errorHandler: errorHandler);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.sendRequest((client) async {
                  final httpResponse = await client.get(Uri.parse('$baseUrl/endpoint'));
                  return HttpResponse.fromResponse(httpResponse);
                });
              } on Error catch (error) {
                // Assert
                expect(error, isA<TypeError>());
                verify(() => errorHandler.onError(any(), any())).called(1);
              }
            },
          );

          test(
            'Should call the handleException method when catch an Exception',
            () async {
              // Arrange
              when(() => customClient.send(any())).thenThrow(HttpExceptionBadRequest());
              final options = HttpOptions(baseUrl: baseUrl, exceptionHandler: exceptionHandler);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.sendRequest((client) async {
                  final httpResponse = await client.get(Uri.parse('$baseUrl/endpoint'));
                  return HttpResponse.fromResponse(httpResponse);
                });
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                verify(() => exceptionHandler.onException(any(), any())).called(1);
              }
            },
          );

          // TODO: Test Request Callback
        },
      );

      group(
        'createClient() |',
        () {
          test(
            'Should return a HttpInterceptClient when creating the client',
            () async {
              // Arrange
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              // Act
              final interceptClient = client.createClient(
                options.delayBetweenRetries,
                options.responseHandler,
                options.requestHandler,
                options.extraRetries,
                options.showLogs,
                options.requestTimeout,
              );

              // Assert
              expect(interceptClient, isA<HttpInterceptClient>());
            },
          );

          // TODO: Test Retry
        },
      );

      group(
        'getCompleteHeaders() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            // registerFallbackValue(HttpExceptionUnauthorized());
            // registerFallbackValue(TypeError());
            // registerFallbackValue(StackTrace.current);
            registerFallbackValue(
              Uri.parse('$baseUrl/endpoint?name=João'),
            );
          });

          tearDown(() {
            reset(customClient);
            // reset(errorHandler);
            // reset(exceptionHandler);
            resetMocktailState();
          });

          test(
            'Should return a HttpResponse when gets a successfull response',
            () async {
              // Arrange
              const body = "";
              const headers = Constants.applicationJsonHeaders;
              const queryParams = {'name': 'João'};
              const statusCode = 200;
              when(
                () => customClient.delete(
                  any(),
                  body: any(named: 'body'),
                  headers: any(named: 'headers'),
                  encoding: any(named: 'encoding'),
                ),
              ).thenAnswer(
                (_) async => http.Response(
                  body,
                  statusCode,
                  headers: headers,
                  request: http.Request(
                    'DELETE',
                    Uri.parse('$baseUrl/endpoint'),
                  ),
                ),
              );
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.delete(
                '/endpoint',
                body: body,
                headers: headers,
                queryParameters: queryParams,
              );

              // Assert
              expect(response.statusCode, equals(statusCode));
              verify(() => customClient.delete(any())).called(1);
            },
          );
        },
      );
    },
  );
}
