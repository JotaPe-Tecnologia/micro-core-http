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

import 'dart:async';

import 'package:dio/dio.dart' as dio;

part '../enums/authorization_type_enum.dart';

/// Class that handles the http request's authorization.
final class AuthorizationOptions {
  /// The key that will be used to add the authorization token on the request.
  ///
  /// The default value is `Authorization`.
  final String authorizationKey;

  /// The type of authorization that will be used.
  ///
  /// Available Types:
  ///
  /// - [AuthorizationTypeEnum.header]
  /// - [AuthorizationTypeEnum.queryParameter]
  ///
  /// The default value is [AuthorizationTypeEnum.header].
  final AuthorizationTypeEnum authorizationType;

  /// The function that determines if the request should be retried.
  final FutureOr<String> Function() getAuthorizationToken;

  const AuthorizationOptions({
    required this.getAuthorizationToken,
    this.authorizationKey = 'Authorization',
    this.authorizationType = AuthorizationTypeEnum.header,
  });

  /// Method that adds the authorization tokens on the request.
  FutureOr<void> addAuthorizationToken(dio.RequestOptions options) async {
    if (options.extra['authorization'] ?? false) {
      final authorizationToken = await getAuthorizationToken();

      if (authorizationType == AuthorizationTypeEnum.header) {
        options.headers[authorizationKey] = authorizationToken;
      }

      if (authorizationType == AuthorizationTypeEnum.queryParameter) {
        options.queryParameters[authorizationKey] = authorizationToken;
      }
    }
  }
}
