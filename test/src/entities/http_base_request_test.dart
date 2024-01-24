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

import 'package:http/http.dart' as http;
import 'package:micro_core_http/src/entities/http_base_request.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpBaseRequest |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should return a http.BaseRequest when creating the HttpBaseRequest',
            () {
              // Arrange
              const method = 'POST';
              const url = 'https://api.jotapetecnologia.com.br/packages';

              // Act
              final baseRequest = HttpBaseRequest(
                method,
                Uri.parse(url),
              );

              // Assert
              expect(baseRequest, isA<HttpBaseRequest>());
              expect(baseRequest, isA<http.BaseRequest>());
            },
          );
        },
      );
    },
  );
}
