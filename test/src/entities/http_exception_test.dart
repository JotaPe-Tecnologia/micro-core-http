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

import 'package:micro_core_http/src/entities/http_exception.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpException |',
    () {
      group(
        'statusCode |',
        () {
          test(
            'Should return an instance if has a valid statusCode',
            () {
              // Arrange
              const validStatusCode = 400;

              // Act
              final result = HttpException(
                statusCode: validStatusCode,
                statusMessage: 'statusMessage',
              );

              // Assert
              expect(result, isA<HttpException>());
            },
          );

          test(
            'Should throw an AssertionError if has a invalid statusCode',
            () {
              // Arrange
              const invalidStatusCode = 0;

              try {
                // Act
                final _ = HttpException(
                  statusCode: invalidStatusCode,
                  statusMessage: 'statusMessage',
                );
              } on AssertionError catch (error) {
                // Assert
                expect(error.message, equals('[ HttpException ] > Invalid Error Status Code'));
              }
            },
          );
        },
      );
    },
  );
}
