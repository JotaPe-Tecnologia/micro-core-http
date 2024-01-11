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
import 'package:http/retry.dart';
import 'package:micro_core_http/src/interfaces/http_request_handler_interface.dart';

import '../entities/http_exception.dart';
import '../entities/http_options.dart';
import '../entities/http_request.dart';
import '../entities/http_response.dart';
import '../interfaces/http_client_interface.dart';
import '../interfaces/http_response_handler_interface.dart';
import '../utils/uri_utils.dart';
import 'http_intercept_client.dart';
import 'http_timeout_client.dart';

/// Class that handles the creation of the HTTP client and sending requests.
final class HttpClient implements IHttpClient {
  /// All the configuration needed to define the behavior of the HTTP clients.
  final HttpOptions options;

  const HttpClient({required this.options});

  /// Method that creates the HTTP client to send the request.
  static HttpInterceptClient _createClient(
    Duration delayBetweenRetries,
    IHttpResponseHandler responseHandler,
    IHttpRequestHandler requestHandler,
    int extraRetries,
    bool showLogs,
    Duration timeout,
  ) {
    final inner = http.Client();

    return HttpInterceptClient(
      RetryClient(
        HttpTimeoutClient(
          inner,
          timeout,
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
  Future<HttpResponse> _sendRequest(
    Future<HttpResponse> Function(HttpInterceptClient client) request,
  ) async {
    HttpInterceptClient? client;

    try {
      client = _createClient(
        options.delayBetweenRetries,
        options.responseHandler,
        options.requestHandler,
        options.extraRetries,
        options.showLogs,
        options.requestTimeout,
      );

      return await request(client);
    } on HttpException catch (exception, stackTrace) {
      // Logging exception
      if (options.showLogs) {
        options.exceptionHandler.logException(exception, stackTrace);
      }

      // Custom onException method from the [IHttpExceptionHandler]
      options.exceptionHandler.onException(exception, stackTrace);

      rethrow;
    } on Error catch (error, stackTrace) {
      // Logging error
      if (options.showLogs) {
        options.errorHandler.logError(error, stackTrace);
      }

      // Custom onError method from the [IHttpErrorHandler]
      options.errorHandler.onError(error, stackTrace);

      rethrow;
    } finally {
      client?.close();
    }
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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.delete(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.get(
          uri,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.head(
          uri,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.patch(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.post(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
  }) async {
    final completeQueryParams = <String, dynamic>{};
    final completeHeaders = <String, String>{};

    // Authenticating the request based on the [IHttpAuthorizationHandler]
    if (authenticate) {
      if (options.authorizationHandler.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }

      if (options.authorizationHandler.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorizationHandler.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    // Creating URI
    final uri = UriUtils.create(
      replaceBaseUrl ?? options.baseUrl,
      endpoint: endpoint,
      queryParameters: completeQueryParams,
    );

    return _sendRequest(
      (client) async {
        final httpResponse = await client.put(
          uri,
          body: body,
          headers: completeHeaders,
          segment: segment,
          step: step,
        );

        HttpRequest? request;

        if (httpResponse.request != null) {
          request = HttpRequest.fromBaseRequest(
            httpResponse.request!,
            segment: segment,
            step: step,
          );
        }

        // Custom reconizeException method from the [IHttpExceptionHandler]
        options.exceptionHandler.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

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
      },
    );
  }
}
