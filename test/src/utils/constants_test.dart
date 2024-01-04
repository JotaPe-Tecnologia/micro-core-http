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

import 'package:micro_core_http/src/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Constants - delayBetweenRetries',
    () {
      test(
        '| Should return a Duration of 1 second as the default value',
        () {
          // Arrange
          const expectedDurationInSeconds = 1;

          // Act
          final delay = Constants.delayBetweenRetries;

          // Assert
          expect(delay.inSeconds, equals(expectedDurationInSeconds));
        },
      );
    },
  );

  group(
    'Constants - requestTimeout',
    () {
      test(
        '| Should return a Duration of 10 seconds as the default value',
        () {
          // Arrange
          const expectedDurationInSeconds = 10;

          // Act
          final delay = Constants.requestTimeout;

          // Assert
          expect(delay.inSeconds, equals(expectedDurationInSeconds));
        },
      );
    },
  );

  group(
    'Constants - extraRetries',
    () {
      test(
        '| Should return 0 as the default value',
        () {
          // Arrange
          const expectedExtraRetries = 0;

          // Act
          final extraRetries = Constants.extraRetries;

          // Assert
          expect(extraRetries, equals(expectedExtraRetries));
        },
      );
    },
  );

  group(
    'Constants - showLogs',
    () {
      test(
        '| Should return false as the default value',
        () {
          // Arrange
          const expectedShowLogs = false;

          // Act
          final showLogs = Constants.showLogs;

          // Assert
          expect(showLogs, equals(expectedShowLogs));
        },
      );
    },
  );
}
