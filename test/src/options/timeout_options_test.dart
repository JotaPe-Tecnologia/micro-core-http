import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/options/timeout_options.dart';

void main() {
  group(
    'connectTimeout |',
    () {
      test(
        'Should return the correct default values when getting the connectTimeout',
        () {
          // Arrange
          const timeoutOptions = TimeoutOptions();

          // Act
          final connectTimeout = timeoutOptions.connectTimeout;

          // Assert
          expect(connectTimeout, equals(const Duration(seconds: 3)));
        },
      );
    },
  );

  group(
    'receiveTimeout |',
    () {
      test(
        'Should return the correct default values when getting the receiveTimeout',
        () {
          // Arrange
          const timeoutOptions = TimeoutOptions();

          // Act
          final receiveTimeout = timeoutOptions.receiveTimeout;

          // Assert
          expect(receiveTimeout, equals(const Duration(seconds: 12)));
        },
      );
    },
  );

  group(
    'sendTimeout |',
    () {
      test(
        'Should return the correct default values when getting the sendTimeout',
        () {
          // Arrange
          const timeoutOptions = TimeoutOptions();

          // Act
          final sendTimeout = timeoutOptions.sendTimeout;

          // Assert
          expect(sendTimeout, equals(const Duration(seconds: 9)));
        },
      );
    },
  );
}
