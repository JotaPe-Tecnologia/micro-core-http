import 'package:micro_core_http/micro_core_http.dart';

abstract interface class IHttpAdapter {
  Future<HttpResponse> delete(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  Future<HttpResponse> get(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  Future<HttpResponse> patch(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  Future<HttpResponse> post(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  Future<HttpResponse> put(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });
}
