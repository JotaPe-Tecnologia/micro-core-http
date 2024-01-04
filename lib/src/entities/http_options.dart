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

import '../defaults/default_http_authorization.dart';
import '../defaults/default_http_error.dart';
import '../defaults/default_http_exception.dart';
import '../interfaces/http_authorization_interface.dart';
import '../utils/constants.dart';
import 'http_exception.dart';
import 'http_request.dart';
import 'http_response.dart';

final class HttpOptions {
  ///
  final IHttpAuthorization authorization;

  ///
  final String baseUrl;

  ///
  final Duration delayBetweenRetries;

  ///
  final void Function(HttpException exception, StackTrace stackTrace)? onException;

  ///
  final void Function(Error error, StackTrace stackTrace)? onError;

  ///
  final HttpRequest Function(HttpRequest)? onRequest;

  ///
  final HttpResponse Function(HttpResponse)? onResponse;

  ///
  final Duration requestTimeout;

  /// `n` retries means that the request will be sent at most `n + 1` times.
  final int extraRetries;

  ///
  final bool showLogs;

  const HttpOptions({
    this.authorization = const DefaultHttpAuthorization(),
    required this.baseUrl,
    this.delayBetweenRetries = Constants.delayBetweenRetries,
    this.onException = DefaultHttpException.onException,
    this.onError = DefaultHttpError.onError,
    this.onRequest,
    this.onResponse,
    this.requestTimeout = Constants.requestTimeout,
    this.extraRetries = Constants.extraRetries,
    this.showLogs = Constants.showLogs,
  });
}
