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

import 'package:micro_core_http/src/utils/uri_utils.dart';
import 'package:test/test.dart';

void main() {
  const endpoint = '/packages';
  const httpsBaseUrl = 'https://api.jotapetecnologia.com.br';
  const httpBaseUrl = 'http://api.jotapetecnologia.com.br';
  const mailtoBaseUrl = 'mailto:contato@jotapetecnologia.com.br';
  const queryParameters = {
    'key0': 'value0',
    'key1': ['value1', 'value11', 'value111'],
    'key2': null,
    'key3': 0,
  };

  group(
    'UriUtils - generateUri',
    () {
      test(
        '| Should return a Uri with https scheme',
        () {
          // Arrange
          const expectedAuthority = 'api.jotapetecnologia.com.br';
          const expectedOrigin = 'https://api.jotapetecnologia.com.br';
          const expectedPath = '/packages';
          const expectedPort = 443;
          const expectedScheme = 'https';

          // Act
          final uri = UriUtils.generateUri(
            httpsBaseUrl,
            endpoint: endpoint,
            queryParameters: queryParameters,
          );

          // Assert
          expect(uri.authority, equals(expectedAuthority));
          expect(uri.origin, equals(expectedOrigin));
          expect(uri.path, equals(expectedPath));
          expect(uri.port, equals(expectedPort));
          expect(uri.scheme, equals(expectedScheme));
        },
      );

      test(
        '| Should return a Uri with http scheme',
        () {
          // Arrange
          const expectedAuthority = 'api.jotapetecnologia.com.br';
          const expectedOrigin = 'http://api.jotapetecnologia.com.br';
          const expectedPath = '/packages';
          const expectedPort = 80;
          const expectedScheme = 'http';

          // Act
          final uri = UriUtils.generateUri(
            httpBaseUrl,
            endpoint: endpoint,
            queryParameters: queryParameters,
          );

          // Assert
          expect(uri.authority, equals(expectedAuthority));
          expect(uri.origin, equals(expectedOrigin));
          expect(uri.path, equals(expectedPath));
          expect(uri.port, equals(expectedPort));
          expect(uri.scheme, equals(expectedScheme));
        },
      );

      test(
        '| Should return a Uri with custom scheme',
        () {
          // Arrange
          const expectedAuthority = '';
          const expectedPath = 'contato@jotapetecnologia.com.br';
          const expectedPort = 0;
          const expectedScheme = 'mailto';

          // Act
          final uri = UriUtils.generateUri(
            mailtoBaseUrl,
          );

          // Assert
          expect(uri.authority, equals(expectedAuthority));
          expect(uri.path, equals(expectedPath));
          expect(uri.port, equals(expectedPort));
          expect(uri.scheme, equals(expectedScheme));
        },
      );

      test(
        '| Should parse the queryParameters data',
        () {
          // Arrange
          const expectedKey0 = 'value0';
          const expectedKey1 = '[value1, value11, value111]';
          const expectedKey2 = '';
          const expectedKey3 = '0';

          // Act
          final uri = UriUtils.generateUri(
            httpsBaseUrl,
            queryParameters: queryParameters,
          );

          // Assert
          expect(uri.queryParameters['key0'], equals(expectedKey0));
          expect(uri.queryParameters['key1'], equals(expectedKey1));
          expect(uri.queryParameters['key2'], equals(expectedKey2));
          expect(uri.queryParameters['key3'], equals(expectedKey3));
        },
      );
    },
  );
}
