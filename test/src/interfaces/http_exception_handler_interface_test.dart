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

import 'package:micro_core_http/src/entities/entities.dart' show HttpRequest;
import 'package:micro_core_http/src/exceptions/exceptions.dart';
import 'package:micro_core_http/src/interfaces/http_exception_handler_interface.dart';
import 'package:test/test.dart';

void main() {
  const requestMethod = 'GET';
  const requestUrl = 'https://api.jotapetecnologia.com.br/packages';
  final statusMessage = 'statusMessage';
  final stackTrace = StackTrace.current;
  final request = HttpRequest(requestMethod, Uri.parse(requestUrl));

  group(
    'IHttpExceptionHandler - reconizeLibExceptions',
    () {
      test(
        "| Should return null if the statusCode is 200",
        () {
          // Arrange
          const successStatusCode = 200;

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            successStatusCode,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isNull);
        },
      );

      test(
        "| Should return a HttpExceptionBadRequest if the statusCode is 400",
        () {
          // Arrange
          const badRequestStatusCode = 400;
          const badRequestMessage = '[ 400 - Bad Request ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            400,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionBadRequest>());
          expect(suggestedException?.statusCode, equals(badRequestStatusCode));
          expect(suggestedException?.statusMessage, equals(badRequestMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionUnauthorized if the statusCode is 401",
        () {
          // Arrange
          const unauthorizedStatusCode = 401;
          const unauthorizedMessage = '[ 401 - Unauthorized ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            401,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionUnauthorized>());
          expect(suggestedException?.statusCode, equals(unauthorizedStatusCode));
          expect(suggestedException?.statusMessage, equals(unauthorizedMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionForbidden if the statusCode is 403",
        () {
          // Arrange
          const forbiddenStatusCode = 403;
          const forbiddenMessage = '[ 403 - Forbidden ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            403,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionForbidden>());
          expect(suggestedException?.statusCode, equals(forbiddenStatusCode));
          expect(suggestedException?.statusMessage, equals(forbiddenMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionNotFound if the statusCode is 404",
        () {
          // Arrange
          const notFoundStatusCode = 404;
          const notFoundMessage = '[ 404 - Not Found ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            404,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionNotFound>());
          expect(suggestedException?.statusCode, equals(notFoundStatusCode));
          expect(suggestedException?.statusMessage, equals(notFoundMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionMethodNotAllowed if the statusCode is 405",
        () {
          // Arrange
          const methodNotAllowedStatusCode = 405;
          const methodNotAllowedMessage = '[ 405 - Method Not Allowed ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            405,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionMethodNotAllowed>());
          expect(suggestedException?.statusCode, equals(methodNotAllowedStatusCode));
          expect(suggestedException?.statusMessage, equals(methodNotAllowedMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionRequestTimeout if the statusCode is 408",
        () {
          // Arrange
          const requestTimeoutStatusCode = 408;
          const requestTimeoutMessage = '[ 408 - Request Timeout ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            408,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionRequestTimeout>());
          expect(suggestedException?.statusCode, equals(requestTimeoutStatusCode));
          expect(suggestedException?.statusMessage, equals(requestTimeoutMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionUnsupportedMediaType if the statusCode is 415",
        () {
          // Arrange
          const unsupportedMediaTypeStatusCode = 415;
          const unsupportedMediaTypeMessage = '[ 415 - Unsupported Media Type ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            415,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionUnsupportedMediaType>());
          expect(suggestedException?.statusCode, equals(unsupportedMediaTypeStatusCode));
          expect(suggestedException?.statusMessage, equals(unsupportedMediaTypeMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionInternalServerError if the statusCode is 500",
        () {
          // Arrange
          const internalServerErrorStatusCode = 500;
          const internalServerErrorMessage = '[ 500 - Internal Server Error ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            500,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionInternalServerError>());
          expect(suggestedException?.statusCode, equals(internalServerErrorStatusCode));
          expect(suggestedException?.statusMessage, equals(internalServerErrorMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionRequestTimeout if the statusCode is 504",
        () {
          // Arrange
          const gatewayTimeoutStatusCode = 504;
          const gatewayTimeoutMessage = '[ 504 - Gateway Timeout ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            504,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionRequestTimeout>());
          expect(suggestedException?.statusCode, equals(gatewayTimeoutStatusCode));
          expect(suggestedException?.statusMessage, equals(gatewayTimeoutMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );

      test(
        "| Should return a HttpExceptionInternalServerError if the statusCode is 509",
        () {
          // Arrange
          const specificServerErrorStatusCode = 509;
          const specificServerErrorMessage = '[ 509 - Internal Server Error ] statusMessage';

          // Act
          final suggestedException = IHttpExceptionHandler.reconizeLibExceptions(
            509,
            description: statusMessage,
            stackTrace: stackTrace,
            request: request,
          );

          // Assert
          expect(suggestedException, isA<HttpExceptionInternalServerError>());
          expect(suggestedException?.statusCode, equals(specificServerErrorStatusCode));
          expect(suggestedException?.statusMessage, equals(specificServerErrorMessage));
          expect(suggestedException?.request?.url.toString(), equals(requestUrl));
        },
      );
    },
  );
}
