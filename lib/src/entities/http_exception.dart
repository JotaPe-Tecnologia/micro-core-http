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

/// Class that represents an HTTP exception.
final class HttpException extends dio.DioException {
  /// Optional description of the module/service that the request is supposed to hit.
  final String? segment;

  /// Optional description of what the request is supposed to do.
  final String? step;

  HttpException({
    required super.requestOptions,
    super.error,
    super.message,
    super.response,
    this.segment,
    StackTrace? stackTrace,
    this.step,
    super.type = dio.DioExceptionType.unknown,
  });

  /// Factory that creates a [HttpException] from a [dio.DioException].
  factory HttpException.fromDioException(dio.DioException exception) {
    return HttpException(
      requestOptions: exception.requestOptions,
      response: exception.response,
      type: exception.type,
      error: exception.error,
      stackTrace: exception.stackTrace,
      message: exception.message,
      segment: exception.requestOptions.extra['segment'],
      step: exception.requestOptions.extra['step'],
    );
  }
}
