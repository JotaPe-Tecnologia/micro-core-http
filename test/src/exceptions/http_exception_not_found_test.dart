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

import 'package:micro_core_http/src/exceptions/http_exception_not_found.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpExceptionNotFound |',
    () {
      test(
        'The default status code value should be 404',
        () {
          // Arrange
          const defaultStatusCode = 404;

          // Act
          const exception = HttpExceptionNotFound();

          // Assert
          expect(exception.statusCode, equals(defaultStatusCode));
        },
      );

      test(
        'The default status message value should be "[ 404 - Not Found ]"',
        () {
          // Arrange
          const defaultStatusMessage = '[ 404 - Not Found ]';

          // Act
          const exception = HttpExceptionNotFound();

          // Assert
          expect(exception.statusMessage, equals(defaultStatusMessage));
        },
      );

      test(
        'The status message value should contain the description when passed',
        () {
          // Arrange
          const description = 'description';
          const statusMessage = '[ 404 - Not Found ] $description';

          // Act
          const exception = HttpExceptionNotFound(
            description: description,
          );

          // Assert
          expect(exception.statusMessage, equals(statusMessage));
        },
      );
      
      test(
        'Should be able to replace all attributes when calling copyWith()',
        () {
          // Arrange
          const exception = HttpExceptionNotFound(
            description: 'description',
          );

          // Assert
          expect(exception.code, equals(404));
          expect(exception.reason, equals('Not Found'));
          expect(exception.description?.trim(), equals('description'));

          // Act
          final newException = exception.copyWith(
            code: 500,
            reason: 'Internal Server Error',
            description: 'new description',
          );

          // Assert
          expect(newException.code, equals(500));
          expect(newException.reason, equals('Internal Server Error'));
          expect(newException.description?.trim(), equals('new description'));
        },
      );
    },
  );
}
