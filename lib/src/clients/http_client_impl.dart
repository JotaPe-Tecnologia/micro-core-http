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

import 'package:dio/dio.dart' as dio;
import 'package:dio/io.dart' as dio_io;

import '../entities/http_response.dart';
import '../interceptors/authorization_interceptor.dart';
import '../interceptors/logger_interceptor.dart';
import '../interceptors/refresh_interceptor.dart';
import '../interceptors/retry_interceptor.dart';
import '../interfaces/http_client.dart';
import '../options/authorization_options.dart';
import '../options/pinning_options.dart';
import '../options/refresh_options.dart';
import '../options/retry_options.dart';
import '../options/timeout_options.dart';

/// Class that implements [HttpClient] using [dio.Dio].
final class HttpClientImpl implements HttpClient {
  /// Options for adding the authorization tokens on the requests.
  final AuthorizationOptions? authorization;

  /// Instance of [dio.Dio] that will be used to make the requests.
  final dio.Dio _dio;

  /// List of interceptors to be added to the [dio.Dio] instance.
  final List<dio.Interceptor>? interceptors;

  /// Options for pinning the requests with SSL Certificates.
  final PinningOptions? pinning;

  /// Options for refreshing the authentication tokens.
  final RefreshOptions? refresh;

  /// Options for retrying a failed request.
  final RetryOptions? retry;

  /// Flag that indicates if the logs should be shown.
  final bool showLogs;

  HttpClientImpl(
    String baseUrl, {
    this.authorization,
    this.interceptors,
    this.pinning,
    this.refresh,
    this.retry,
    this.showLogs = false,
    TimeoutOptions timeout = const TimeoutOptions(),
  }) : _dio = dio.Dio(
          dio.BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: timeout.connectTimeout,
            receiveTimeout: timeout.receiveTimeout,
            sendTimeout: timeout.sendTimeout,
          ),
        ) {
    addInterceptors();
    addCertificates();
  }

  /// Add interceptors to the [dio.Dio] instance.
  void addInterceptors() {
    if (interceptors == null || interceptors!.isEmpty) return;
    _dio.interceptors.addAll(interceptors!);

    _dio.interceptors.addAll([
      if (authorization != null) AuthorizationInterceptor(authorization!),
      LoggerInterceptor(),
      if (refresh != null) RefreshInterceptor(refresh!, client: _dio),
      if (retry != null) RetryInterceptor(retry!, client: _dio),
    ]);
  }

  /// Add certificates to the [dio.Dio] instance.
  void addCertificates() {
    if (pinning == null) return;

    _dio.httpClientAdapter = dio_io.IOHttpClientAdapter(
      createHttpClient: pinning?.createHttpClient,
      validateCertificate: pinning?.validateCertificate,
    );
  }

  @override
  Future<HttpResponse<T>> delete<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.delete<T>(
      endpoint,
      data: body,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse<T>.fromDioResponse(response);
  }

  @override
  Future<HttpResponse> download(
    String endpoint,
    String pathToSave, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.download(
      endpoint,
      pathToSave,
      data: body,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse.fromDioResponse(response);
  }

  @override
  Future<HttpResponse<T>> get<T>(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.get<T>(
      endpoint,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse<T>.fromDioResponse(response);
  }

  @override
  Future<HttpResponse<T>> patch<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.patch<T>(
      endpoint,
      data: body,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse<T>.fromDioResponse(response);
  }

  @override
  Future<HttpResponse<T>> post<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.post<T>(
      endpoint,
      data: body,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse<T>.fromDioResponse(response);
  }

  @override
  Future<HttpResponse<T>> put<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  }) async {
    final response = await _dio.put<T>(
      endpoint,
      data: body,
      queryParameters: queryParameters,
      options: dio.Options(
        headers: headers,
        extra: {
          'authorization': authenticate,
          'segment': segment,
          'showLogs': showLogs ?? this.showLogs,
          'step': step,
        },
      ),
    );

    return HttpResponse<T>.fromDioResponse(response);
  }
}
