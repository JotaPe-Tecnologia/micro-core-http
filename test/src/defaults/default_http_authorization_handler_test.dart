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

import 'package:micro_core_http/src/defaults/default_http_authorization_handler.dart';
import 'package:micro_core_http/src/enums/http_authorization_type.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpAuthorizationHandler |',
    () {
      group(
        'authorizationType |',
        () {
          test(
            'The defualt value of authorizationType should be HttpAuthorizationType.noAuthorization',
            () {
              // Arrange
              const authorizationHandler = DefaultHttpAuthorizationHandler();

              // Act
              final authorizationType = authorizationHandler.authorizationType;

              // Assert
              expect(authorizationType, equals(HttpAuthorizationType.noAuthorization));
            },
          );
        },
      );

      group(
        'getAuthorization() |',
        () {
          test(
            'The defualt value of getAuthorization() should be an empty Map<String, String>',
            () async {
              // Arrange
              const authorizationHandler = DefaultHttpAuthorizationHandler();

              // Act
              final authorization = await authorizationHandler.getAuthorization();

              // Assert
              expect(authorization, isA<Map<String, String>>());
              expect(authorization.isEmpty, isTrue);
            },
          );
        },
      );
    },
  );
}
