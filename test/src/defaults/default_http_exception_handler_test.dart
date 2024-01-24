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

import 'package:micro_core_http/src/defaults/default_http_exception_handler.dart';
import 'package:micro_core_http/src/entities/http_exception.dart';
import 'package:micro_core_http/src/entities/http_request.dart';
import 'package:micro_core_http/src/exceptions/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpExceptionHandler |',
    () {
      group(
        'logException() |',
        () {
          test(
            'Should print on terminal the attributes values',
            () {
              // Arrange 
              const exception = HttpException(
                statusCode: 400,
                statusMessage: 'statusMessage',
              );
              final stackTrace = StackTrace.current;
              final exceptionHandler = DefaultHttpExceptionHandler();

              // Act
              exceptionHandler.logException(exception, stackTrace);
            },
          );
        },
      );
      
      group(
        'onException() |',
        () {
          test(
            'Should be able to call onException method',
            () {
              // Arrange 
              const exception = HttpException(
                statusCode: 400,
                statusMessage: 'statusMessage',
              );
              final stackTrace = StackTrace.current;
              final exceptionHandler = DefaultHttpExceptionHandler();

              // Act
              exceptionHandler.onException(exception, stackTrace);
            },
          );
        },
      );

      group(
        'reconizeCustomExceptions() |',
        () {
          final request = HttpRequest(
            'get',
            Uri.parse('https://www.jotapetecnologia.com.br'),
            segment: 'segment',
            step: 'step',
          );

          test(
            'Should return HttpExceptionBadRequest when statusCode is exactly 400',
            () {
              // Arrange
              const statusCode = 400;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Bad Request ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionBadRequest catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionUnauthorized when statusCode is exactly 401',
            () {
              // Arrange
              const statusCode = 401;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Unauthorized ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionUnauthorized catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionForbidden when statusCode is exactly 403',
            () {
              // Arrange
              const statusCode = 403;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Forbidden ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionForbidden catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionNotFound when statusCode is exactly 404',
            () {
              // Arrange
              const statusCode = 404;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Not Found ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionNotFound catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionMethodNotAllowed when statusCode is exactly 405',
            () {
              // Arrange
              const statusCode = 405;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Method Not Allowed ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionMethodNotAllowed catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionRequestTimeout when statusCode is exactly 408',
            () {
              // Arrange
              const statusCode = 408;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Request Timeout ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionRequestTimeout catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionUnsupportedMediaType when statusCode is exactly 415',
            () {
              // Arrange
              const statusCode = 415;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Unsupported Media Type ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionUnsupportedMediaType catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionInternalServerError when statusCode is exactly 500',
            () {
              // Arrange
              const statusCode = 500;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Internal Server Error ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionInternalServerError catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionRequestTimeout when statusCode is exactly 504',
            () {
              // Arrange
              const statusCode = 504;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Gateway Timeout ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionRequestTimeout catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should return HttpExceptionInternalServerError when statusCode is greater than 500',
            () {
              // Arrange
              const statusCode = 509;
              const expectedStatusCode = statusCode;
              const expectedStatusMessage = '[ $statusCode - Internal Server Error ] statusMessage';

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpExceptionInternalServerError catch (exception) {
                // Assert
                expect(exception.statusCode, expectedStatusCode);
                expect(exception.statusMessage, expectedStatusMessage);
              }
            },
          );

          test(
            'Should throw no HttpKnownException when statusCode is not mapped',
            () {
              // Arrange
              const statusCode = 499;

              try {
                // Act
                DefaultHttpExceptionHandler().reconizeCustomExceptions(
                  statusCode,
                  'statusMessage',
                  StackTrace.current,
                  request: request,
                );
              } on HttpKnownException catch (_) {
                // Assert
                expect(true, isFalse);
              }
            },
          );
        },
      );
    },
  );
}
