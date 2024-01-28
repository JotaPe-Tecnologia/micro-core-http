import 'package:micro_core_http/micro_core_http.dart';

import 'interfaces/http_adapter_interface.dart';

final class HttpAdapter implements IHttpAdapter {
  final HttpOptions options;

  const HttpAdapter(this.options);

  static const Map<String, String> defaultHeaders = {
    "accept": "*/*",
    "content-type": "application/json",
  };

  @override
  Future<HttpResponse> delete(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers = defaultHeaders,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    final client = HttpClient(
      options: options,
    );

    return client.delete(
      endpoint,
      authenticate: authenticate,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      replaceBaseUrl: replaceBaseUrl,
      segment: segment,
      step: step,
    );
  }

  @override
  Future<HttpResponse> get(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers = defaultHeaders,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    final client = HttpClient(
      options: options,
    );

    return client.get(
      endpoint,
      authenticate: authenticate,
      headers: headers,
      queryParameters: queryParameters,
      replaceBaseUrl: replaceBaseUrl,
      segment: segment,
      step: step,
    );
  }

  @override
  Future<HttpResponse> patch(
    String endpoint, {
    bool authenticate = false,
    body,
    Map<String, String>? headers = defaultHeaders,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    final client = HttpClient(
      options: options,
    );

    return client.patch(
      endpoint,
      authenticate: authenticate,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      replaceBaseUrl: replaceBaseUrl,
      segment: segment,
      step: step,
    );
  }

  @override
  Future<HttpResponse> post(
    String endpoint, {
    bool authenticate = false,
    body,
    Map<String, String>? headers = defaultHeaders,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    final client = HttpClient(
      options: options,
    );

    return client.post(
      endpoint,
      authenticate: authenticate,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      replaceBaseUrl: replaceBaseUrl,
      segment: segment,
      step: step,
    );
  }

  @override
  Future<HttpResponse> put(
    String endpoint, {
    bool authenticate = false,
    body,
    Map<String, String>? headers = defaultHeaders,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  }) {
    final client = HttpClient(
      options: options,
    );

    return client.put(
      endpoint,
      authenticate: authenticate,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      replaceBaseUrl: replaceBaseUrl,
      segment: segment,
      step: step,
    );
  }
}
