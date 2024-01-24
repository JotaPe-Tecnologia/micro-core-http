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

import 'package:micro_core_http/src/defaults/default_http_request_handler.dart';
import 'package:micro_core_http/src/entities/http_request.dart';
import 'package:micro_core_http/src/interfaces/http_request_handler_interface.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpRequestHandler |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be extending the IHttpRequestHandler',
            () {
              // Act
              final requestHandler = DefaultHttpRequestHandler();

              // Assert
              expect(requestHandler, isA<IHttpRequestHandler>());
            },
          );
        },
      );

      group(
        'logRequest() |',
        () {
          test(
            'Should print on terminal the attributes values',
            () {
              // Arrange
              final request = HttpRequest(
                'GET',
                Uri.parse('https://api.jotapetecnologia.com.br/packages'),
              );
              final requestHandler = DefaultHttpRequestHandler();

              // Act
              requestHandler.logRequest(request);
            },
          );
        },
      );

      group(
        'onRequest() |',
        () {
          test(
            'Should be able to call onRequest method',
            () {
              // Arrange
              final request = HttpRequest(
                'GET',
                Uri.parse('https://api.jotapetecnologia.com.br/packages'),
              );
              final requestHandler = DefaultHttpRequestHandler();

              // Act
              requestHandler.onRequest(request);
            },
          );
        },
      );
    },
  );
}
