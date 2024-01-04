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

import '../entities/http_exception.dart';
import '../entities/http_request.dart';
import '../exceptions/exceptions.dart';

abstract interface class DefaultHttpException {
  static const exceptions = [
    HttpExceptionBadRequest(),
    HttpExceptionForbidden(),
    HttpExceptionInternalServerError(),
    HttpExceptionMethodNotAllowed(),
    HttpExceptionNotFound(),
    HttpExceptionRequestTimeout(),
    HttpExceptionUnauthorized(),
    HttpExceptionUnsupportedMediaType(),
  ];

  static void onException(HttpException exception, StackTrace stackTrace) {
    print('''${exception.toString()}[ ${exception.runtimeType} ] - StackTrace     | $stackTrace
[ ${exception.runtimeType} ] -----------------------------------------
''');
  }

  static void reconizeException(
    int statusCode,
    String? statusMessage,
    StackTrace? stackTrace, {
    HttpRequest? request,
  }) {
    final exceptionIndex = exceptions.indexWhere(
      (exception) => exception.statusCode == statusCode,
    );
    if (exceptionIndex != -1) {
      throw exceptions[exceptionIndex];
    }

    if (statusCode == 504) {
      throw HttpExceptionRequestTimeout(
        code: statusCode,
        reason: 'Gateway Timeout',
        request: request,
        statusMessage: statusMessage,
      );
    }

    if (statusCode > 500) {
      throw HttpExceptionInternalServerError(
        code: statusCode,
        reason: 'Internal Server Error',
        request: request,
        statusMessage: statusMessage,
      );
    }
  }
}
