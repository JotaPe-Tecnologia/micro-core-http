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

import 'package:micro_core_http/src/defaults/default_http_response_handler.dart';
import 'package:micro_core_http/src/entities/http_response.dart';
import 'package:micro_core_http/src/interfaces/http_response_handler_interface.dart';
import 'package:micro_core_http/src/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpResponseHandler |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be extending the IHttpResponseHandler',
            () {
              // Act
              final responseHandler = DefaultHttpResponseHandler();

              // Assert
              expect(responseHandler, isA<IHttpResponseHandler>());
            },
          );
        },
      );

      group(
        'logResponse() |',
        () {
          test(
            'Should print on terminal the attributes values',
            () {
              // Arrange 
              final response = HttpResponse(
                data: {'name': 'JotaPe'},
                headers: Constants.applicationJsonHeaders,
                statusCode: 200,
              );
              final responseHandler = DefaultHttpResponseHandler();

              // Act
              responseHandler.logResponse(response);
            },
          );
        },
      );
      
      group(
        'onResponse() |',
        () {
          test(
            'Should be able to call onResponse method',
            () {
              // Arrange 
              final response = HttpResponse(
                data: {'name': 'JotaPe'},
                headers: Constants.applicationJsonHeaders,
                statusCode: 200,
              );
              final responseHandler = DefaultHttpResponseHandler();

              // Act
              responseHandler.onResponse(response);
            },
          );
        },
      );
    },
  );
}
