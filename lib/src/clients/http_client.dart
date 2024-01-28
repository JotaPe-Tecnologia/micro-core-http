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
import 'package:http/retry.dart' as retry;

import '../entities/entities.dart' show HttpException, HttpOptions, HttpRequest, HttpResponse;
import '../interfaces/interfaces.dart' show IHttpClient, IHttpExceptionHandler, IHttpRequestHandler, IHttpResponseHandler;
import '../utils/uri_utils.dart';
import 'http_intercept_client.dart';
import 'http_timeout_client.dart';

/// Class that handles the creation of the HTTP client and sending requests.
final class HttpClient implements IHttpClient {
  /// All the configuration needed to define the behavior of the HTTP clients.
  final HttpOptions options;

  /// Custom HTTP client to override the inner client.
  final http.Client? customClient;

  const HttpClient({required this.options, this.customClient});

  /// Method that handles a [Error].
  void handleError(Error error, StackTrace stackTrace) {
    // Logging error
    if (options.showLogs) {
      options.errorHandler.logError(error, stackTrace);
    }

    // Custom onError method from the [IHttpErrorHandler]
    options.errorHandler.onError(error, stackTrace);
  }

  /// Method that handles the [HttpException] and returns a [HttpResponse].
  ///
  /// Also executes the [IHttpRefreshHandler.refreshTokenAndRetryRequest] flow.
  Future<HttpResponse> handleException(
    HttpException exception,
    StackTrace stackTrace,
    Future<HttpResponse> Function() request,
  ) async {
    // Logging exception
    if (options.showLogs) {
      options.exceptionHandler.logException(exception, stackTrace);
    }

    // Custom onException method from the [IHttpExceptionHandler]
    options.exceptionHandler.onException(exception, stackTrace);

    // Custom refreshTokenAndRetryRequest method from the [IHttpRefreshHandler]
    if (options.refreshTokenAndRetryRequest && exception.statusCode == options.refreshHandler.statusCode()) {
      final response = await options.refreshHandler.refreshTokenAndRetryRequest(request);
      return response;
    }

    throw exception;
  }

  /// Method that creates the HTTP client to send the request.
  HttpInterceptClient createClient(
    Duration delayBetweenRetries,
    IHttpResponseHandler responseHandler,
    IHttpRequestHandler requestHandler,
    int extraRetries,
    bool showLogs,
    Duration requestTimeout,
  ) {
    final inner = customClient ?? http.Client();

    return HttpInterceptClient(
      retry.RetryClient(
        HttpTimeoutClient(
          inner,
          requestTimeout,
        ),
        retries: extraRetries,
        delay: (_) => delayBetweenRetries,
        when: (_) => false,
        whenError: (_, __) => true,
      ),
      requestHandler,
      showLogs: showLogs,
    );
  }

  /// Method that sends the request.
  Future<HttpResponse> sendRequest(
    Future<HttpResponse> Function(HttpInterceptClient client) request,
  ) async {
    HttpInterceptClient? client;

    try {
      client = createClient(
        options.delayBetweenRetries,
        options.responseHandler,
        options.requestHandler,
        options.extraRetries,
        options.showLogs,
        options.requestTimeout,
      );

      final response = await request(client);
      return response;
    } on HttpException catch (exception, stackTrace) {
      final response = await handleException(
        exception,
        stackTrace,
        () => request(client!),
      );
      return response;
    } on Error catch (error, stackTrace) {
      handleError(error, stackTrace);
      rethrow;
    } finally {
      client?.close();
    }
  }

  /// Method that generates the complete headers base on the [IHttpAuthorizationHandler] and the headers passed.
  Future<Map<String, String>> getCompleteHeaders(
    bool authenticate,
    Map<String, String>? headers,
  ) async {
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate && options.authorizationHandler.authorizationType.isHeaders) {
      final authorizationHeaders = await options.authorizationHandler.getAuthorization();
      completeHeaders.addAll(authorizationHeaders);
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    return completeHeaders;
  }

  /// Method that generates the complete query parameters base on the [IHttpAuthorizationHandler] and the query parameters passed.
  Future<Map<String, dynamic>?> getCompleteQueryParameters(
    bool authenticate,
    Map<String, dynamic>? queryParameters,
  ) async {
    final completeQueryParams = <String, dynamic>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate && options.authorizationHandler.authorizationType.isQueryParams) {
      final authorizationQueryParams = await options.authorizationHandler.getAuthorization();
      completeQueryParams.addAll(authorizationQueryParams);
    }

    if (queryParameters != null) {
      completeQueryParams.addAll(queryParameters);
    }

    return completeQueryParams.isEmpty ? null : completeQueryParams;
  }

  /// Method that creates the [Uri] based on the [baseUrl] and the [endpoint].
  /// 
  /// Also handles the override of baseUrl with [replaceBaseUrl].
  Uri createUri(
    String endpoint, {
    String? replaceBaseUrl,
    Map<String, dynamic>? queryParameters,
  }) {
    if (replaceBaseUrl != null && replaceBaseUrl.isNotEmpty) {
      return UriUtils.create(
        replaceBaseUrl,
        endpoint: endpoint,
        queryParameters: queryParameters,
      );
    }

    return UriUtils.create(
      options.baseUrl,
      endpoint: endpoint,
      queryParameters: queryParameters,
    );
  }

  /// Method that parses the [http.Response] into a [HttpResponse].
  /// 
  /// Also executes the [IHttpResponseHandler.logResponse] and [IHttpResponseHandler.onResponse] methods.
  HttpResponse parseHttpResponse(
    http.Response httpResponse, {
    String? segment,
    String? step,
  }) {
    // Parsing the [http.Response] into a [HttpResponse]
    final response = HttpResponse.fromResponse(
      httpResponse,
      segment: segment,
      step: step,
    );

    // Logging response
    if (options.showLogs) {
      options.responseHandler.logResponse(response);
    }

    // Custom onResponse method from the [IHttpResponseHandler]
    options.responseHandler.onResponse(response);

    return response;
  }

  /// Method that validates if the [http.Response] should be treated as an [HttpException] based on its status code.
  void validateIfResponseShouldBeTreatedAsException(
    http.Response httpResponse, {
    String? segment,
    String? step,
  }) {
    HttpRequest? request;

    if (httpResponse.request != null) {
      request = HttpRequest.fromBaseRequest(
        httpResponse.request!,
        segment: segment,
        step: step,
      );
    }

    // Getting the suggested HttpException
    final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
      httpResponse.statusCode,
      description: httpResponse.reasonPhrase,
      stackTrace: StackTrace.current,
      request: request,
    );

    // Custom reconizeException method from the [IHttpExceptionHandler]
    options.exceptionHandler.reconizeCustomExceptions(
      httpResponse.statusCode,
      httpResponse.reasonPhrase,
      StackTrace.current,
      request: request,
      suggestedException: suggestedException,
    );
  }

  /// Method that generates the [Uri] and the complete headers.
  Future<(Uri, Map<String, String>)> getRequestAttributes(
    String endpoint,
    bool authenticate, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
  }) async {
    final requestAttributes = await Future.wait([
      // Generating the complete query parameters base on the [IHttpAuthorizationHandler]
      getCompleteHeaders(authenticate, headers),

      // Generating the complete headers base on the [IHttpAuthorizationHandler]
      getCompleteQueryParameters(authenticate, queryParameters),
    ]);

    // Generating URI
    final uri = createUri(
      endpoint,
      replaceBaseUrl: replaceBaseUrl,
      queryParameters: requestAttributes[1],
    );

    return (uri, requestAttributes[0] as Map<String, String>);
  }

  /// Method that executes the [validateIfResponseShouldBeTreatedAsException] and [parseHttpResponse] methods.
  HttpResponse validateExceptionAndParseResponse(
    http.Response httpResponse, {
    String? segment,
    String? step,
  }) {
    validateIfResponseShouldBeTreatedAsException(
      httpResponse,
      segment: segment,
      step: step,
    );

    // Parsing the [http.Response] into a [HttpResponse]
    final response = parseHttpResponse(
      httpResponse,
      segment: segment,
      step: step,
    );

    return response;
  }

  @override
  Future<HttpResponse> delete(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.delete(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }

  @override
  Future<HttpResponse> get(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.get(
          uri,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }

  @override
  Future<HttpResponse> head(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.head(
          uri,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }

  @override
  Future<HttpResponse> patch(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.patch(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }

  @override
  Future<HttpResponse> post(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.post(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }

  @override
  Future<HttpResponse> put(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    return sendRequest(
      (client) async {
        // Getting Uri and Headers
        final (uri, completeHeaders) = await getRequestAttributes(
          endpoint,
          authenticate,
          headers: headers,
          queryParameters: queryParameters,
          replaceBaseUrl: replaceBaseUrl,
        );

        // Sending the request
        final httpResponse = await client.put(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        return validateExceptionAndParseResponse(
          httpResponse,
          segment: segment,
          step: step,
        );
      },
    );
  }
}
