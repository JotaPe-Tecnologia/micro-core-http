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

import '../entities/http_exception.dart';
import '../options/retry_options.dart';

part '../extensions/request_attempt_extension.dart';

/// A [dio.Interceptor] that retries the requests that have failed given a condition.
final class RetryInterceptor extends dio.Interceptor {
  /// The [dio.Dio] instance that will be used to retry the requests.
  final dio.Dio client;

  /// Options to retry the requests that failed.
  final RetryOptions retry;

  const RetryInterceptor(this.retry, {required this.client});

  /// Retries the request if it fails.
  @override
  void onError(
    dio.DioException err,
    dio.ErrorInterceptorHandler handler,
  ) async {
    // If the error is a BadCertificateException, send the error to the handler.
    if (err.type == dio.DioExceptionType.badCertificate) {
      return handler.reject(HttpException.fromDioException(err));
    }

    // If we should not retry the request, send the error to the handler.
    if (!retry.shouldRetry(err.response?.statusCode, err.response?.data)) {
      return handler.reject(HttpException.fromDioException(err));
    }

    if (err.requestOptions.attempt >= (retry.retries)) {
      return handler.reject(HttpException.fromDioException(err));
    }

    await Future.delayed(retry.retryInterval);
    err.requestOptions.incrementAttempt();
    try {
      final response = await client.fetch<void>(err.requestOptions);
      return handler.resolve(response);
    } on dio.DioException catch (_) {
      return handler.reject(HttpException.fromDioException(err));
    }
  }
}
