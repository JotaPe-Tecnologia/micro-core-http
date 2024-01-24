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

import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:micro_core_http/src/entities/http_media_type.dart';
import 'package:test/test.dart';

void main() {
  group(
    'HttpMediaType |',
    () {
      group(
        'Extension |',
        () {
          test(
            'Should be an extension of http_parser.MediaType',
            () {
              // Arrange
              const type = 'image';
              const subtype = 'png';

              // Act
              final mediaType = HttpMediaType(type, subtype);

              // Assert
              expect(mediaType, isA<http_parser.MediaType>());
              expect(mediaType.type, equals(type));
              expect(mediaType.subtype, equals(subtype));
            },
          );
        },
      );
    },
  );
}
