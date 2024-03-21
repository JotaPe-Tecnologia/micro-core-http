import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/interceptors/retry_interceptor.dart';

void main() {
  group(
    'attempt |',
    () {
      test(
        'Should return 0 when the request has not been attempted',
        () {
          // Arrange
          final options = dio.RequestOptions();

          // Act
          final result = options.attempt;

          // Assert
          expect(result, equals(0));
        },
      );

      test(
        'Should return 1 when the request has been attempted once',
        () {
          // Arrange
          final options = dio.RequestOptions();

          // Act
          options.extra['attempt'] = 1;
          final result = options.attempt;

          // Assert
          expect(result, equals(1));
        },
      );
    },
  );

  group(
    'incrementAttempt() |',
    () {
      test(
        'Should increment the number of attempts by 1 (1 attempts scenario)',
        () {
          // Arrange
          final options = dio.RequestOptions();

          // Act
          options.incrementAttempt();
          final result = options.attempt;

          // Assert
          expect(result, equals(1));
        },
      );
      
      test(
        'Should increment the number of attempts by 1 (2 attempts scenario)',
        () {
          // Arrange
          final options = dio.RequestOptions();

          // Act
          options.incrementAttempt();
          options.incrementAttempt();
          final result = options.attempt;

          // Assert
          expect(result, equals(2));
        },
      );
    },
  );
}
