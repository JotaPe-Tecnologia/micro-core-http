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

import '../defaults/defaults.dart';
import '../interfaces/interfaces.dart' hide IHttpClient;
import '../utils/constants.dart';

/// All the configuration needed to define the behavior of the HTTP clients.
final class HttpOptions {
  /// The handler of the request's authorization.
  final IHttpAuthorizationHandler authorizationHandler;

  /// The defualt base url.
  final String baseUrl;

  /// The duration that the client will wait to retry the request after a timeout.
  final Duration delayBetweenRetries;

  /// The handler of the request's error.
  final IHttpErrorHandler errorHandler;

  /// The handler of the request's exception.
  final IHttpExceptionHandler exceptionHandler;

  /// The handler of the refresh token flow.
  ///
  /// To work properly the [refreshTokenAndRetryRequest] should be `true`.
  final IHttpRefreshHandler refreshHandler;

  /// The handler of the request's response.
  final IHttpResponseHandler responseHandler;

  /// The handler of the request.
  final IHttpRequestHandler requestHandler;

  /// The duration that the client will wait for a response after sending the request.
  final Duration requestTimeout;

  /// The number of retries that the client will send the request after the first time.
  ///
  /// `n` retries means that the request will be sent at most `n + 1` times.
  final int extraRetries;

  /// The flag that activates all the out of the box logs.
  ///
  /// It will log all the requests, responses, exceptions and errors.
  final bool showLogs;

  /// The flag that activates the flow of refreshing an expired token and retrying.
  ///
  /// The flow will work properly when you activate this flag and implement the [IHttpRefreshHandler].
  final bool refreshTokenAndRetryRequest;

  const HttpOptions({
    this.authorizationHandler = const DefaultHttpAuthorizationHandler(),
    required this.baseUrl,
    this.delayBetweenRetries = Constants.delayBetweenRetries,
    this.errorHandler = const DefaultHttpErrorHandler(),
    this.exceptionHandler = const DefaultHttpExceptionHandler(),
    this.refreshHandler = const DefaultHttpRefreshHandler(),
    this.refreshTokenAndRetryRequest = Constants.refreshTokenAndRetryRequest,
    this.requestHandler = const DefaultHttpRequestHandler(),
    this.responseHandler = const DefaultHttpResponseHandler(),
    this.requestTimeout = Constants.requestTimeout,
    this.extraRetries = Constants.extraRetries,
    this.showLogs = Constants.showLogs,
  });
}
