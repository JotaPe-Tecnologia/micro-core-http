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

import 'package:micro_core_http/src/enums/http_authorization_type.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpAuthorizationType |',
    () {
      group(
        'isHeaders |',
        () {
          test(
            'Should return true when the type is HttpAuthorizationType.headers',
            () {
              // Arrange
              const type = HttpAuthorizationType.headers;

              // Act
              final result = type.isHeaders;

              // Assert
              expect(result, isTrue);
            },
          );
          
          test(
            'Should return true when the type is not HttpAuthorizationType.headers',
            () {
              // Arrange
              const type = HttpAuthorizationType.queryParams;

              // Act
              final result = type.isHeaders;

              // Assert
              expect(result, isFalse);
            },
          );
        },
      );
      
      group(
        'isQueryParams |',
        () {
          test(
            'Should return true when the type is HttpAuthorizationType.queryParams',
            () {
              // Arrange
              const type = HttpAuthorizationType.queryParams;

              // Act
              final result = type.isQueryParams;

              // Assert
              expect(result, isTrue);
            },
          );
          
          test(
            'Should return true when the type is not HttpAuthorizationType.queryParams',
            () {
              // Arrange
              const type = HttpAuthorizationType.noAuthorization;

              // Act
              final result = type.isQueryParams;

              // Assert
              expect(result, isFalse);
            },
          );
        },
      );
      
      group(
        'isNoAuthorization |',
        () {
          test(
            'Should return true when the type is HttpAuthorizationType.noAuthorization',
            () {
              // Arrange
              const type = HttpAuthorizationType.noAuthorization;

              // Act
              final result = type.isNoAuthorization;

              // Assert
              expect(result, isTrue);
            },
          );
          
          test(
            'Should return true when the type is not HttpAuthorizationType.noAuthorization',
            () {
              // Arrange
              const type = HttpAuthorizationType.headers;

              // Act
              final result = type.isNoAuthorization;

              // Assert
              expect(result, isFalse);
            },
          );
        },
      );
    },
  );
}
