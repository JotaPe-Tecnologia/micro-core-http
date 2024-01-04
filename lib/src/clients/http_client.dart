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
import 'package:micro_core_http/src/defaults/default_http_exception.dart';

import '../entities/http_exception.dart';
import '../entities/http_options.dart';
import '../entities/http_request.dart';
import '../entities/http_response.dart';
import '../interfaces/http_client_interface.dart';
import '../utils/uri_utils.dart';
import 'http_intercept_client.dart';
import 'http_timeout_client.dart';

final class HttpClient implements IHttpClient {
  ///
  final HttpOptions options;

  const HttpClient({required this.options});

  static HttpInterceptClient _createClient(
    Duration delayBetweenRetries,
    void Function(HttpRequest)? onRequest,
    void Function(HttpResponse)? onResponse,
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
      onRequest: onRequest,
      onResponse: onResponse,
      showLogs: showLogs,
    );
  }

  Future<HttpResponse> _sendRequest(
    Future<HttpResponse> Function(HttpInterceptClient client) request,
  ) async {
    HttpInterceptClient? client;

    try {
      client = _createClient(
        options.delayBetweenRetries,
        options.onRequest,
        options.onResponse,
        options.extraRetries,
        options.showLogs,
        options.requestTimeout,
      );

      return await request(client);
    } on HttpException catch (exception, stackTrace) {
      if (options.showLogs) {
        options.onException?.call(exception, stackTrace);
      }
      rethrow;
    } on Error catch (error, stackTrace) {
      if (options.showLogs) {
        options.onError?.call(error, stackTrace);
      }
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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

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

    if (authenticate) {
      if (options.authorization.authorizationType.isHeaders) {
        completeHeaders.addAll(
          await options.authorization.getAuthorization(),
        );
      }

      if (options.authorization.authorizationType.isQueryParams) {
        completeQueryParams.addAll(
          await options.authorization.getAuthorization(),
        );
      }
    }

    if (headers != null) {
      completeHeaders.addAll(headers);
    }

    final uri = UriUtils.generateUri(
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

        DefaultHttpException.reconizeException(
          httpResponse.statusCode,
          httpResponse.reasonPhrase,
          StackTrace.current,
          request: request,
        );

        final response = HttpResponse.fromResponse(
          httpResponse,
          segment: segment,
          step: step,
        );

        if (options.showLogs) {
          print(response);
        }

        options.onResponse?.call(response);

        return response;
      },
    );
  }
}
