import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/options/retry_options.dart';

void main() {
  const retries = 3;
  const retryInterval = Duration(seconds: 2);
  bool shouldRetry(int? statusCode, dynamic data) {
    if (statusCode == 400) {
      return true;
    }

    return false;
  }

  group(
    'retries |',
    () {
      test(
        'Should return the correct value of retries when getting retries',
        () {
          // Arrange
          final retryOptions = RetryOptions(
            retries: retries,
            retryInterval: retryInterval,
            shouldRetry: shouldRetry,
          );

          // Act
          final result = retryOptions.retries;

          // Assert
          expect(result, equals(3));
        },
      );
    },
  );

  group(
    'retryInterval |',
    () {
      test(
        'Should return the correct value of retryInterval when getting retryInterval',
        () {
          // Arrange
          final retryOptions = RetryOptions(
            retries: retries,
            retryInterval: retryInterval,
            shouldRetry: shouldRetry,
          );

          // Act
          final result = retryOptions.retryInterval;

          // Assert
          expect(result, equals(const Duration(seconds: 2)));
        },
      );
    },
  );

  group(
    'shouldRetry() |',
    () {
      test(
        'Should return true if statusCode is 400 when calling shouldRetry()',
        () {
          // Arrange
          const statusCode = 400;
          final retryOptions = RetryOptions(
            retries: retries,
            retryInterval: retryInterval,
            shouldRetry: shouldRetry,
          );

          // Act
          final result = retryOptions.shouldRetry(statusCode, null);

          // Assert
          expect(result, isTrue);
        },
      );
      
      test(
        'Should return false if statusCode is not 400 when calling shouldRetry()',
        () {
          // Arrange
          const statusCode = 401;
          final retryOptions = RetryOptions(
            retries: retries,
            retryInterval: retryInterval,
            shouldRetry: shouldRetry,
          );

          // Act
          final result = retryOptions.shouldRetry(statusCode, null);

          // Assert
          expect(result, isFalse);
        },
      );
    },
  );
}
