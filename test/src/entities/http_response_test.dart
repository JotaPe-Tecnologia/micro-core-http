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

import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/entities/http_response.dart';

void main() {
  group(
    'extendability |',
    () {
      test(
        'Should create a DioResponse when creating a HttpResponse',
        () {
          // Arrange - Act
          final exception = HttpResponse(
            requestOptions: dio.RequestOptions(),
          );

          // Assert
          expect(exception, isA<dio.Response>());
        },
      );
    },
  );

  group(
    'fromDioResponse() |',
    () {
      test(
        'Should return a HttpResponse with correct data when parsing a DioResponse',
        () {
          // Arrange
          const requestPath = '/v1/path';
          final dioResponse = dio.Response(
            requestOptions: dio.RequestOptions(path: requestPath),
          );

          // Act
          final httpResponse = HttpResponse.fromDioResponse(dioResponse);

          // Assert
          expect(httpResponse, isA<HttpResponse>());
          expect(httpResponse.requestOptions.path, equals(requestPath));
        },
      );

      test(
        'Should return a HttpResponse with correct segment and step when parsing a DioResponse',
        () {
          // Arrange
          const segment = 'segment';
          const step = 'step';
          final dioResponse = dio.Response(
            requestOptions: dio.RequestOptions(
              extra: {
                'segment': segment,
                'step': step,
              },
            ),
          );

          // Act
          final httpResponse = HttpResponse.fromDioResponse(dioResponse);

          // Assert
          expect(httpResponse, isA<HttpResponse>());
          expect(httpResponse.segment, equals(segment));
          expect(httpResponse.step, equals(step));
        },
      );
    },
  );
}
