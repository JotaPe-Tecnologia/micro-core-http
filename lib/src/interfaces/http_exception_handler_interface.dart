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

import '../entities/entities.dart' show HttpException, HttpOptions, HttpRequest;
import '../exceptions/exceptions.dart';

/// Class to implement the methods that handle exceptions.
abstract base class IHttpExceptionHandler {
  const IHttpExceptionHandler();

  /// List of library's known exceptions.
  static const List<HttpKnownException> knownExceptions = [
    HttpExceptionBadRequest(),
    HttpExceptionForbidden(),
    HttpExceptionInternalServerError(),
    HttpExceptionMethodNotAllowed(),
    HttpExceptionNotFound(),
    HttpExceptionRequestTimeout(),
    HttpExceptionUnauthorized(),
    HttpExceptionUnsupportedMediaType(),
  ];

  /// Method that prints the [HttpException] on terminal if the [HttpOptions.showLogs] is true.
  void logException(HttpException exception, StackTrace stackTrace);

  /// Method that runs when an exception occurs.
  ///
  /// The default behavior is to print on the terminal all the exceptions's data.
  void onException(HttpException exception, StackTrace stackTrace);

  /// Method that runs after receiving the response to validate the response and reconize custom exceptions.
  ///
  /// The default behavior is to throw all the [HttpKnownException] based on its [HttpKnownException.statusCode] value:
  ///
  /// - 400 [HttpExceptionBadRequest]
  /// - 401 [HttpExceptionUnauthorized]
  /// - 403 [HttpExceptionForbidden]
  /// - 404 [HttpExceptionNotFound]
  /// - 405 [HttpExceptionMethodNotAllowed]
  /// - 408, 504 [HttpExceptionRequestTimeout]
  /// - 415 [HttpExceptionUnsupportedMediaType]
  /// - 500, ..., 599 [HttpExceptionInternalServerError]
  void reconizeException(int statusCode, String? statusMessage, StackTrace? stackTrace, {HttpRequest? request});
}
