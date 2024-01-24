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

import 'package:micro_core_http/src/defaults/default_http_refresh_handler.dart';
import 'package:micro_core_http/src/entities/http_response.dart';
import 'package:micro_core_http/src/interfaces/http_refresh_handler_interface.dart';
import 'package:micro_core_http/src/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DefaultHttpRefreshHandler |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be extending the IHttpRefreshHandler',
            () {
              // Act
              final refreshHandler = DefaultHttpRefreshHandler();

              // Assert
              expect(refreshHandler, isA<IHttpRefreshHandler>());
            },
          );
        },
      );

      group(
        'statusCode |',
        () {
          test(
            'Should get the default statusCode value when the refresh flow triggers',
            () {
              // Arrange
              const expectedStatusCode = 401;
              final refreshHandler = DefaultHttpRefreshHandler();

              // Act
              final statusCode = refreshHandler.statusCode();

              // Assert
              expect(statusCode, expectedStatusCode);
            },
          );
        },
      );

      group(
        'refreshTokenAndRetryRequest() |',
        () {
          test(
            'Should be able to call onRefresh method',
            () async {
              // Arrange
              const expectedData = {'name': 'JotaPe'};
              const expectedHeaders = Constants.applicationJsonHeaders;
              const expectedStatusCode = 200;
              final response = HttpResponse(
                data: expectedData,
                headers: expectedHeaders,
                statusCode: expectedStatusCode,
              );
              final refreshHandler = DefaultHttpRefreshHandler();

              // Act
              final result = await refreshHandler.refreshTokenAndRetryRequest(
                () async => response,
              );

              // Assert
              expect(result.data, expectedData);
              expect(result.headers, expectedHeaders);
              expect(result.statusCode, expectedStatusCode);
            },
          );
        },
      );
    },
  );
}
