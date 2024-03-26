import 'package:dio/dio.dart' as dio;
import 'package:flutter_test/flutter_test.dart';
import 'package:micro_core_http/src/options/authorization_options.dart';

void main() {
  const String authorizationToken = 'Bearer token';
  Future<String> getAuthorizationToken() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return authorizationToken;
  }

  // late dio.RequestOptions requestWithAuthorization;
  // late dio.RequestOptions requestWithoutAuthorization;

  // setUp(
  //   () {
  //     requestWithAuthorization = dio.RequestOptions(
  //       path: 'https://www.google.com',
  //       extra: {'authorization': true},
  //     );
  //     requestWithoutAuthorization = dio.RequestOptions(
  //       path: 'https://www.google.com',
  //     );
  //   },
  // );

  final requestWithAuthorization = dio.RequestOptions(
    path: 'https://www.google.com',
    extra: {'authorization': true},
  );
  final requestWithoutAuthorization = dio.RequestOptions(
    path: 'https://www.google.com',
  );

  group(
    'authorizationKey |',
    () {
      test(
        'Should have "Authorization" as the default value',
        () {
          // Arrange
          const expected = 'Authorization';
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
          );

          // Act
          final result = authorizationOptions.authorizationKey;

          // Assert
          expect(result, equals(expected));
        },
      );

      test(
        'Should be able to override the default value',
        () {
          // Arrange
          const expected = 'Authorization2';
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
            authorizationKey: expected,
          );

          // Act
          final result = authorizationOptions.authorizationKey;

          // Assert
          expect(result, equals(expected));
        },
      );
    },
  );

  group(
    'authorizationType |',
    () {
      test(
        'Should have "AuthorizationTypeEnum.header" as the default value',
        () {
          // Arrange
          const expected = AuthorizationTypeEnum.header;
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
          );

          // Act
          final result = authorizationOptions.authorizationType;

          // Assert
          expect(result, equals(expected));
        },
      );

      test(
        'Should be able to override the default value',
        () {
          // Arrange
          const expected = AuthorizationTypeEnum.queryParameter;
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
            authorizationType: expected,
          );

          // Act
          final result = authorizationOptions.authorizationType;

          // Assert
          expect(result, equals(expected));
        },
      );
    },
  );

  group(
    'addAuthorizationToken() |',
    () {
      test(
        'Headers | Should add the correct token on the right place when the '
        'request needs authorization',
        () async {
          // Arrange
          const expected = 'Bearer token';
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
          );

          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);

          // Act
          await authorizationOptions.addAuthorizationToken(
            requestWithAuthorization,
          );

          // Assert
          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isNotEmpty);
          expect(
            requestWithAuthorization.headers[authorizationOptions.authorizationKey],
            equals(expected),
          );
        },
      );

      test(
        'Query Params | Should add the correct token on the right place when '
        'the request needs authorization',
        () async {
          // Arrange
          const expected = 'Bearer token';
          final authorizationOptions =
              AuthorizationOptions(getAuthorizationToken: getAuthorizationToken, authorizationType: AuthorizationTypeEnum.queryParameter);

          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);

          // Act
          await authorizationOptions.addAuthorizationToken(
            requestWithAuthorization,
          );

          // Assert
          expect(requestWithAuthorization.queryParameters, isNotEmpty);
          expect(requestWithAuthorization.headers, isEmpty);
          expect(
            requestWithAuthorization.queryParameters[authorizationOptions.authorizationKey],
            equals(expected),
          );
        },
      );

      test(
        'Headers | Should not add the correct token on the right place when '
        'the request does not need authorization',
        () async {
          // Arrange
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
          );

          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);

          // Act
          await authorizationOptions.addAuthorizationToken(
            requestWithoutAuthorization,
          );

          // Assert
          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);
        },
      );

      test(
        'Query Params | Should not add the correct token on the right place '
        'when the request does not need authorization',
        () async {
          // Arrange
          final authorizationOptions = AuthorizationOptions(
            getAuthorizationToken: getAuthorizationToken,
            authorizationType: AuthorizationTypeEnum.queryParameter,
          );

          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);

          // Act
          await authorizationOptions.addAuthorizationToken(
            requestWithoutAuthorization,
          );

          // Assert
          expect(requestWithAuthorization.queryParameters, isEmpty);
          expect(requestWithAuthorization.headers, isEmpty);
        },
      );
    },
  );
}
