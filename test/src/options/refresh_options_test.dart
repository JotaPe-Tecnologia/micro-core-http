import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/options/refresh_options.dart';
import 'package:mocktail/mocktail.dart';

final class MockClient extends Mock implements dio.Dio {}

void main() {
  bool tokenIsRefreshed = false;
  Future<void> refreshTokens(dio.Dio client) async {
    tokenIsRefreshed = true;
  }

  group(
    'statusCodeToRefresh |',
    () {
      test(
        'Should return the correct default value when getting statusCodeToRefresh',
        () {
          // Arrange
          final refreshOptions = RefreshOptions(refreshTokens: refreshTokens);

          // Act
          final result = refreshOptions.statusCodeToRefresh;

          // Assert
          expect(result, equals(401));
        },
      );

      test(
        'Should return the correct overriden value when getting statusCodeToRefresh',
        () {
          // Arrange
          final refreshOptions = RefreshOptions(
            refreshTokens: refreshTokens,
            statusCodeToRefresh: 404,
          );

          // Act
          final result = refreshOptions.statusCodeToRefresh;

          // Assert
          expect(result, equals(404));
        },
      );
    },
  );

  group(
    'refreshTokens() |',
    () {
      test(
        'Should change value to true when calling refreshTokens()',
        () async {
          // Arrange
          final refreshOptions = RefreshOptions(
            refreshTokens: refreshTokens,
            statusCodeToRefresh: 404,
          );

          // Assert
          expect(tokenIsRefreshed, isFalse);

          // Act
          await refreshOptions.refreshTokens(MockClient());

          // Assert
          expect(tokenIsRefreshed, isTrue);
        },
      );
    },
  );
}
