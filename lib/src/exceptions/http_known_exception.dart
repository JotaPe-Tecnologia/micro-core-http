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

import 'dart:convert';

import '../entities/http_exception.dart';
import '../entities/http_request.dart';

/// Class that represents a scenario of an known exception.
base class HttpKnownException extends HttpException implements Exception {
  /// The HTTP request that were the cause of the exception.
  final HttpRequest? request;

  const HttpKnownException({
    this.request,
    required int code,
    required String reason,
    String? statusMessage,
  }) : super(
          statusCode: code,
          statusMessage: '[ $code - $reason ] ${statusMessage ?? ""}',
        );

  @override
  String toString() {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return '''
[ $runtimeType ] > A $runtimeType was thrown!
[ $runtimeType ] - Base URL       | ${request?.url.origin}
[ $runtimeType ] - Endpoint       | ${request?.url.path}
[ $runtimeType ] - Query Params   | ${encoder.convert(request?.url.queryParameters)}
[ $runtimeType ] - Headers        | ${encoder.convert(request?.headers)}
[ $runtimeType ] - Segment        | ${request?.segment}
[ $runtimeType ] - Step           | ${request?.step}
[ $runtimeType ] - Status Code    | $statusCode
[ $runtimeType ] - Status Message | $statusMessage
''';
  }
}
