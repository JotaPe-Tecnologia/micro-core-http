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

import 'package:micro_core_http/src/exceptions/http_exception_bad_request.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpExceptionBadRequest |',
    () {
      test(
        'The default status code value should be 400',
        () {
          // Arrange
          const defaultStatusCode = 400;

          // Act
          const exception = HttpExceptionBadRequest();

          // Assert
          expect(exception.statusCode, equals(defaultStatusCode));
        },
      );

      test(
        'The default status message value should be "[ 400 - Bad Request ]"',
        () {
          // Arrange
          const defaultStatusMessage = '[ 400 - Bad Request ]';

          // Act
          const exception = HttpExceptionBadRequest();

          // Assert
          expect(exception.statusMessage, equals(defaultStatusMessage));
        },
      );
      
      test(
        'The status message value should contain the description when passed',
        () {
          // Arrange
          const description = 'description';
          const statusMessage = '[ 400 - Bad Request ] $description';

          // Act
          const exception = HttpExceptionBadRequest(
            description: description,
          );

          // Assert
          expect(exception.statusMessage, equals(statusMessage));
        },
      );
    },
  );
}
