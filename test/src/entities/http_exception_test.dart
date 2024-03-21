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
import 'package:micro_core_http/src/entities/http_exception.dart';

void main() {
  group(
    'extendability |',
    () {
      test(
        'Should create a DioException when creating a HttpException',
        () {
          // Arrange - Act
          final exception = HttpException(
            requestOptions: dio.RequestOptions(),
          );

          // Assert
          expect(exception, isA<dio.DioException>());
        },
      );
    },
  );

  group(
    'fromDioException() |',
    () {
      test(
        'Should return a HttpException with correct data when parsing a DioException',
        () {
          // Arrange
          const requestPath = '/v1/path';
          final dioException = dio.DioException(
            requestOptions: dio.RequestOptions(path: requestPath),
          );

          // Act
          final httpException = HttpException.fromDioException(dioException);

          // Assert
          expect(httpException, isA<HttpException>());
          expect(httpException.requestOptions.path, equals(requestPath));
        },
      );
    },
  );
}
