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

import 'package:micro_core_http/src/defaults/default_http_error_handler.dart';
import 'package:micro_core_http/src/interfaces/http_error_handler_interface.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpErrorHandler |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be extending the IHttpErrorHandler',
            () {
              // Act
              final errorHandler = DefaultHttpErrorHandler();

              // Assert
              expect(errorHandler, isA<IHttpErrorHandler>());
            },
          );
        },
      );

      group(
        'logError() |',
        () {
          test(
            'Should print on terminal the attributes values',
            () {
              // Arrange 
              final error = TypeError();
              final stackTrace = StackTrace.current;
              final errorHandler = DefaultHttpErrorHandler();

              // Act
              errorHandler.logError(error, stackTrace);
            },
          );
        },
      );
      
      group(
        'onError() |',
        () {
          test(
            'Should be able to call onError method',
            () {
              // Arrange 
              final error = TypeError();
              final stackTrace = StackTrace.current;
              final errorHandler = DefaultHttpErrorHandler();

              // Act
              errorHandler.onError(error, stackTrace);
            },
          );
        },
      );
    },
  );
}
