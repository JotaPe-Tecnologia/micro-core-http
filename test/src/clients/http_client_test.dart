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

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:micro_core_http/micro_core_http.dart';
import 'package:micro_core_http/src/clients/http_intercept_client.dart';
import 'package:micro_core_http/src/entities/http_streamed_response.dart';
import 'package:micro_core_http/src/utils/constants.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

final class MockHeaderAuthorizationHandler extends Mock implements IHttpAuthorizationHandler {
  @override
  HttpAuthorizationType get authorizationType => HttpAuthorizationType.headers;
}

final class MockQueryAuthorizationHandler extends Mock implements IHttpAuthorizationHandler {
  @override
  HttpAuthorizationType get authorizationType => HttpAuthorizationType.queryParams;
}

final class MockClient extends Mock implements http.Client {}

final class MockErrorHandler extends Mock implements IHttpErrorHandler {}

final class MockExceptionHandler extends Mock implements IHttpExceptionHandler {}

final class MockRefreshHandler extends Mock implements IHttpRefreshHandler {}

final class MockResponseHandler extends Mock implements IHttpResponseHandler {}

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
        'createUri() |',
        () {
          test(
            'Should return a Uri with HttpOptions.baseUrl when replaceBaseUrl is null',
            () async {
              // Arrange
              const endpoint = '/endpoint';
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              // Act
              final uri = client.createUri(
                endpoint,
              );

              // Assert
              expect(uri.toString(), equals('${options.baseUrl}$endpoint'));
            },
          );

          test(
            'Should return a Uri with replaceBaseUrl when replaceBaseUrl is not null',
            () async {
              // Arrange
              const endpoint = '/endpoint';
              const replaceBaseUrl = 'https://api-dev.jotapetecnologia.com.br';
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              // Act
              final uri = client.createUri(
                endpoint,
                replaceBaseUrl: replaceBaseUrl,
              );

              // Assert
              expect(uri.toString(), isNot(equals('${options.baseUrl}$endpoint')));
              expect(uri.toString(), equals('$replaceBaseUrl$endpoint'));
            },
          );

          test(
            'Should return a Uri with HttpOptions.baseUrl when replaceBaseUrl is an empty String',
            () async {
              // Arrange
              const endpoint = '/endpoint';
              const replaceBaseUrl = '';
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              // Act
              final uri = client.createUri(
                endpoint,
                replaceBaseUrl: replaceBaseUrl,
              );

              // Assert
              expect(uri.toString(), equals('${options.baseUrl}$endpoint'));
              expect(uri.toString(), isNot(equals('$replaceBaseUrl$endpoint')));
            },
          );

          test(
            'Should return a Uri with queryParameters when queryParameters are not null',
            () async {
              // Arrange
              const endpoint = '/endpoint';
              const queryParameters = {'name': 'João'};
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              // Act
              final uri = client.createUri(
                endpoint,
                queryParameters: queryParameters,
              );

              // Assert
              expect(uri.queryParameters, equals(queryParameters));
            },
          );
        },
      );

      group(
        'parseHttpResponse() |',
        () {
          late final IHttpResponseHandler responseHandler;

          setUpAll(() {
            responseHandler = MockResponseHandler();
          });

          setUp(() {
            registerFallbackValue(
              HttpResponse(
                data: {'name': 'João'},
                headers: Constants.applicationJsonHeaders,
                statusCode: 200,
              ),
            );
          });

          tearDown(() {
            reset(responseHandler);
            resetMocktailState();
          });

          test(
            'Should call the IHttpResponseHandler.logResponse callback when HttpOptions.showLogs is true and response is successfully parsed',
            () async {
              // Arrange
              when(() => responseHandler.logResponse(any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                responseHandler: responseHandler,
                showLogs: true,
              );
              final client = HttpClient(options: options);

              // Act
              client.parseHttpResponse(http.Response('{"name": "João"}', 200));

              // Assert
              verify(
                () => options.responseHandler.logResponse(any()),
              ).called(equals(1));
            },
          );

          test(
            'Should not call the IHttpResponseHandler.logResponse callback when HttpOptions.showLogs is false and response is successfully parsed',
            () async {
              // Arrange
              when(() => responseHandler.logResponse(any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                responseHandler: responseHandler,
              );
              final client = HttpClient(options: options);

              // Act
              client.parseHttpResponse(http.Response('{"name": "João"}', 200));

              // Assert
              verifyNever(() => options.responseHandler.logResponse(any()));
            },
          );

          test(
            'Should always call the IHttpResponseHandler.onResponse callback when response is successfully parsed',
            () async {
              // Arrange
              when(() => responseHandler.onResponse(any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                responseHandler: responseHandler,
              );
              final client = HttpClient(options: options);

              // Act
              client.parseHttpResponse(http.Response('{"name": "João"}', 200));

              // Assert
              verify(
                () => options.responseHandler.onResponse(any()),
              ).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when response is successfully parsed',
            () async {
              // Arrange
              when(() => responseHandler.onResponse(any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                responseHandler: responseHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final response = client.parseHttpResponse(http.Response('{"name": "João"}', 200));

              // Assert
              expect(response, isA<HttpResponse>());
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
              expect(response.step, isNull);
              expect(response.segment, isNull);
            },
          );

          test(
            'Should return a HttpResponse with step and segment when they are passed',
            () async {
              // Arrange
              when(() => responseHandler.onResponse(any()));
              final options = HttpOptions(
                baseUrl: baseUrl,
                responseHandler: responseHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final response = client.parseHttpResponse(
                http.Response('{"name": "João"}', 200),
                segment: 'segment',
                step: 'step',
              );

              // Assert
              expect(response, isA<HttpResponse>());
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
              expect(response.step, equals('step'));
              expect(response.segment, equals('segment'));
            },
          );
        },
      );

      group(
        'validateIfResponseShouldBeTreatedAsException() |',
        () {
          late final IHttpExceptionHandler exceptionHandler;

          setUpAll(() {
            exceptionHandler = MockExceptionHandler();
          });

          setUp(() {
            registerFallbackValue(StackTrace.current);
            registerFallbackValue(HttpKnownException(code: 400, reason: 'reason'));
            registerFallbackValue(http.Request('GET', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(exceptionHandler);
            resetMocktailState();
          });

          test(
            'Should throw a HttpException without HttpRequest when HttpResponse has the right statusCode',
            () async {
              // Arrange
              const body = '{"name": "João"}';
              const reasonPhrase = 'reasonPhrase';
              const statusCode = 400;
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              try {
                // Act
                client.validateIfResponseShouldBeTreatedAsException(
                  http.Response(
                    body,
                    statusCode,
                    headers: Constants.applicationJsonHeaders,
                    reasonPhrase: reasonPhrase,
                  ),
                );
              } on HttpExceptionBadRequest catch (exception) {
                // Assert
                expect(exception.statusCode, equals(statusCode));
                expect(exception.description?.trim(), equals(reasonPhrase));
                expect(exception.request, isNull);
              }
            },
          );

          test(
            'Should throw a HttpException with HttpRequest, and without segment, and step when HttpResponse has the right statusCode',
            () async {
              // Arrange
              const body = '{"name": "João"}';
              const reasonPhrase = 'reasonPhrase';
              const statusCode = 400;
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              try {
                // Act
                client.validateIfResponseShouldBeTreatedAsException(
                  http.Response(
                    body,
                    statusCode,
                    headers: Constants.applicationJsonHeaders,
                    reasonPhrase: reasonPhrase,
                    request: http.Request(
                      'GET',
                      Uri.parse('$baseUrl/endpoint'),
                    ),
                  ),
                );
              } on HttpExceptionBadRequest catch (exception) {
                // Assert
                expect(exception.statusCode, equals(statusCode));
                expect(exception.description?.trim(), equals(reasonPhrase));
                expect(exception.request, isNotNull);
                expect(exception.request?.method, equals('GET'));
                expect(exception.request?.url.toString(), equals('$baseUrl/endpoint'));
                expect(exception.request?.segment, isNull);
                expect(exception.request?.step, isNull);
              }
            },
          );

          test(
            'Should throw a HttpException with HttpRequest, segment, and step when HttpResponse has the right statusCode',
            () async {
              // Arrange
              const body = '{"name": "João"}';
              const reasonPhrase = 'reasonPhrase';
              const statusCode = 400;
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options);

              try {
                // Act
                client.validateIfResponseShouldBeTreatedAsException(
                  http.Response(
                    body,
                    statusCode,
                    headers: Constants.applicationJsonHeaders,
                    reasonPhrase: reasonPhrase,
                    request: http.Request(
                      'GET',
                      Uri.parse('$baseUrl/endpoint'),
                    ),
                  ),
                  segment: 'segment',
                  step: 'step',
                );
              } on HttpExceptionBadRequest catch (exception) {
                // Assert
                expect(exception.statusCode, equals(statusCode));
                expect(exception.description?.trim(), equals(reasonPhrase));
                expect(exception.request, isNotNull);
                expect(exception.request?.method, equals('GET'));
                expect(exception.request?.url.toString(), equals('$baseUrl/endpoint'));
                expect(exception.request?.segment, equals('segment'));
                expect(exception.request?.step, equals('step'));
              }
            },
          );

          test(
            'Should always call the IHttpExceptionHandler.reconizeCustomExceptions callback',
            () async {
              // Arrange
              when(
                () => exceptionHandler.reconizeCustomExceptions(
                  any(),
                  any(),
                  any(),
                  suggestedException: any(named: 'suggestedException'),
                  request: any(named: 'request'),
                ),
              );
              const body = '{"name": "João"}';
              const reasonPhrase = 'reasonPhrase';
              const statusCode = 400;
              final options = HttpOptions(baseUrl: baseUrl, exceptionHandler: exceptionHandler);
              final client = HttpClient(options: options);

              // Act
              client.validateIfResponseShouldBeTreatedAsException(
                http.Response(
                  body,
                  statusCode,
                  headers: Constants.applicationJsonHeaders,
                  reasonPhrase: reasonPhrase,
                  request: http.Request(
                    'GET',
                    Uri.parse('$baseUrl/endpoint'),
                  ),
                ),
                segment: 'segment',
                step: 'step',
              );

              verify(
                () => exceptionHandler.reconizeCustomExceptions(
                  any(),
                  any(),
                  any(),
                  suggestedException: any(named: 'suggestedException'),
                  request: any(named: 'request'),
                ),
              ).called(equals(1));
            },
          );
        },
      );

      group(
        'getCompleteHeaders() |',
        () {
          late final IHttpAuthorizationHandler headerAuthorizationHandler;
          late final IHttpAuthorizationHandler queryAuthorizationHandler;

          setUpAll(() {
            headerAuthorizationHandler = MockHeaderAuthorizationHandler();
            queryAuthorizationHandler = MockQueryAuthorizationHandler();
          });

          setUp(() {
            registerFallbackValue(HttpAuthorizationType.noAuthorization);
          });

          tearDown(() {
            reset(headerAuthorizationHandler);
            reset(queryAuthorizationHandler);
            resetMocktailState();
          });

          test(
            'Should return an empty Map<String, String> when authenticate is false and headers is null',
            () async {
              // Arrange
              const authenticate = false;
              final Map<String, String>? headers = null;
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: headerAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeHeaders = await client.getCompleteHeaders(
                authenticate,
                headers,
              );

              // Assert
              expect(completeHeaders, equals({}));
            },
          );

          test(
            'Should return an empty Map<String, String> when authenticate is true, authorizationType is not headers, and headers is null',
            () async {
              // Arrange
              const authenticate = true;
              final Map<String, String>? headers = null;
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: queryAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeHeaders = await client.getCompleteHeaders(
                authenticate,
                headers,
              );

              // Assert
              expect(completeHeaders, equals({}));
            },
          );

          test(
            'Should return a Map<String, String> that has the same data as headers when authenticate is true, authorizationType is not headers, and headers is not null',
            () async {
              // Arrange
              const authenticate = true;
              const headers = {'name': 'João'};
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: queryAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeHeaders = await client.getCompleteHeaders(
                authenticate,
                headers,
              );

              // Assert
              expect(completeHeaders, equals(headers));
            },
          );

          test(
            'Should return a Map<String, String> with authentication data when authenticate is true, authorizationType is headers',
            () async {
              // Arrange
              const authorization = {'name': 'João'};
              when(
                () => headerAuthorizationHandler.getAuthorization(),
              ).thenAnswer((_) async => authorization);
              const authenticate = true;
              const headers = {'age': '25'};
              const expected = {...authorization, ...headers};
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: headerAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeHeaders = await client.getCompleteHeaders(
                authenticate,
                headers,
              );

              // Assert
              expect(completeHeaders, equals(expected));
            },
          );
        },
      );

      group(
        'getCompleteQueryParameters() |',
        () {
          late final IHttpAuthorizationHandler headerAuthorizationHandler;
          late final IHttpAuthorizationHandler queryAuthorizationHandler;

          setUpAll(() {
            headerAuthorizationHandler = MockHeaderAuthorizationHandler();
            queryAuthorizationHandler = MockQueryAuthorizationHandler();
          });

          setUp(() {
            registerFallbackValue(HttpAuthorizationType.noAuthorization);
          });

          tearDown(() {
            reset(headerAuthorizationHandler);
            reset(queryAuthorizationHandler);
            resetMocktailState();
          });

          test(
            'Should return null when authenticate is false and queryParameters is null',
            () async {
              // Arrange
              const authenticate = false;
              final Map<String, String>? queryParameters = null;
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: queryAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeQueryParameters = await client.getCompleteQueryParameters(
                authenticate,
                queryParameters,
              );

              // Assert
              expect(completeQueryParameters, isNull);
            },
          );

          test(
            'Should return null when authenticate is true, authorizationType is not queryParameters, and queryParameters is null',
            () async {
              // Arrange
              const authenticate = true;
              final Map<String, String>? queryParameters = null;
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: headerAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeQueryParameters = await client.getCompleteQueryParameters(
                authenticate,
                queryParameters,
              );

              // Assert
              expect(completeQueryParameters, isNull);
            },
          );

          test(
            'Should return a Map<String, String> that has the same data as queryParameters when authenticate is true, authorizationType is not queryParameters, and queryParameters is not null',
            () async {
              // Arrange
              const authenticate = true;
              const queryParameters = {'name': 'João'};
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: headerAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeQueryParameters = await client.getCompleteQueryParameters(
                authenticate,
                queryParameters,
              );

              // Assert
              expect(completeQueryParameters, equals(queryParameters));
            },
          );

          test(
            'Should return a Map<String, String> with authentication data when authenticate is true, authorizationType is queryParameters',
            () async {
              // Arrange
              const authorization = {'name': 'João'};
              when(
                () => queryAuthorizationHandler.getAuthorization(),
              ).thenAnswer((_) async => authorization);
              const authenticate = true;
              const queryParameters = {'age': '25'};
              const expected = {...authorization, ...queryParameters};
              final options = HttpOptions(
                baseUrl: baseUrl,
                authorizationHandler: queryAuthorizationHandler,
              );
              final client = HttpClient(options: options);

              // Act
              final completeQueryParameters = await client.getCompleteQueryParameters(
                authenticate,
                queryParameters,
              );

              // Assert
              expect(completeQueryParameters, equals(expected));
            },
          );
        },
      );

      group(
        'delete() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('DELETE', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when delete() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.delete('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.delete('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.delete('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );

      group(
        'get() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('GET', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when get() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.get('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.get('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.get('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );

      group(
        'head() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('HEAD', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when head() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.head('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.head('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.head('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );

      group(
        'patch() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('PATCH', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when patch() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.patch('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.patch('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.patch('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );

      group(
        'post() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('POST', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when post() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.post('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.post('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.post('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );

      group(
        'put() |',
        () {
          late final http.Client customClient;

          setUpAll(() {
            customClient = MockClient();
          });

          setUp(() {
            registerFallbackValue(Uri.parse('$baseUrl/endpoint'));
            registerFallbackValue(Utf8Codec());
            registerFallbackValue(http.Request('PUT', Uri.parse('$baseUrl/endpoint')));
          });

          tearDown(() {
            reset(customClient);
            resetMocktailState();
          });

          test(
            'Should call http.Client.send() when put() is called',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              await client.put('/endpoint');

              // Assert
              verify(() => customClient.send(any())).called(equals(1));
            },
          );

          test(
            'Should return a HttpResponse when receives a response with the right statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                200,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              // Act
              final response = await client.put('/endpoint');

              // Assert
              expect(response.statusCode, equals(200));
              expect(response.data, equals({'name': 'João'}));
            },
          );

          test(
            'Should throw a HttpException when receives a response with the wrong statusCode',
            () async {
              // Arrange
              const value = [123, 34, 110, 97, 109, 101, 34, 58, 32, 34, 74, 111, 227, 111, 34, 125];
              final streamedResponse = http.StreamedResponse(
                Stream.value(value),
                400,
              );
              when(
                () => customClient.send(any()),
              ).thenAnswer((_) async => streamedResponse);
              final options = HttpOptions(baseUrl: baseUrl);
              final client = HttpClient(options: options, customClient: customClient);

              try {
                // Act
                await client.put('/endpoint');
              } on HttpException catch (exception) {
                // Assert
                expect(exception, isA<HttpExceptionBadRequest>());
                expect(exception.statusCode, equals(400));
              }
            },
          );
        },
      );
    },
  );
}
