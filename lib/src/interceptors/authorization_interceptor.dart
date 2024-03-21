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

import 'package:dio/dio.dart' as dio;

import '../options/authorization_options.dart';

/// A [dio.Interceptor] that adds the authorization tokens on the request.
final class AuthorizationInterceptor extends dio.Interceptor {
  /// Options to add the authorization tokens on the request.
  final AuthorizationOptions authorization;

  const AuthorizationInterceptor(this.authorization);

  /// Adds the authorization token on the request.
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) {
    authorization.addAuthorizationToken(options);
    return super.onRequest(options, handler);
  }
}
