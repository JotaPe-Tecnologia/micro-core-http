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

import 'package:micro_core_http/src/exceptions/http_exception_unsupported_media_type.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpExceptionUnsupportedMediaType |',
    () {
      test(
        'The default status code value should be 415',
        () {
          // Arrange
          const defaultStatusCode = 415;

          // Act
          const exception = HttpExceptionUnsupportedMediaType();

          // Assert
          expect(exception.statusCode, equals(defaultStatusCode));
        },
      );

      test(
        'The default status message value should be "[ 415 - Unsupported Media Type ]"',
        () {
          // Arrange
          const defaultStatusMessage = '[ 415 - Unsupported Media Type ]';

          // Act
          const exception = HttpExceptionUnsupportedMediaType();

          // Assert
          expect(exception.statusMessage, equals(defaultStatusMessage));
        },
      );

      test(
        'The status message value should contain the description when passed',
        () {
          // Arrange
          const description = 'description';
          const statusMessage = '[ 415 - Unsupported Media Type ] $description';

          // Act
          const exception = HttpExceptionUnsupportedMediaType(
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
          const exception = HttpExceptionUnsupportedMediaType(
            description: 'description',
          );

          // Assert
          expect(exception.code, equals(415));
          expect(exception.reason, equals('Unsupported Media Type'));
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
