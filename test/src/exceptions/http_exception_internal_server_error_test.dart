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

import 'package:micro_core_http/src/exceptions/http_exception_internal_server_error.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpExceptionInternalServerError |',
    () {
      test(
        'The default status code value should be 500',
        () {
          // Arrange
          const defaultStatusCode = 500;

          // Act
          const exception = HttpExceptionInternalServerError();

          // Assert
          expect(exception.statusCode, equals(defaultStatusCode));
        },
      );

      test(
        'The default status message value should be "[ 500 - Internal Server Error ]"',
        () {
          // Arrange
          const defaultStatusMessage = '[ 500 - Internal Server Error ]';

          // Act
          const exception = HttpExceptionInternalServerError();

          // Assert
          expect(exception.statusMessage, equals(defaultStatusMessage));
        },
      );

      test(
        'The status message value should contain the description when passed',
        () {
          // Arrange
          const description = 'description';
          const statusMessage = '[ 500 - Internal Server Error ] $description';

          // Act
          const exception = HttpExceptionInternalServerError(
            description: description,
          );

          // Assert
          expect(exception.statusMessage, equals(statusMessage));
        },
      );
    },
  );
}
