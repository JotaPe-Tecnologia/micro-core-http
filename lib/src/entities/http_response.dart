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

import 'package:http/http.dart' as http;

/// Class that represents the response of a HTTP's request.
final class HttpResponse {
  /// The data on the body of this response.
  final dynamic data;

  /// The HTTP headers returned by the server.
  final Map<String, String> headers;

  /// If the response was triggered by a redirect.
  final bool isRedirect;

  /// Whether the server requested that a persistent connection be maintained.
  final bool persistentConnection;

  /// The HTTP request that triggered this response.
  final http.BaseRequest? request;

  /// Optional description of the module/service that the request is supposed to hit.
  final String? segment;

  /// The HTTP status code for this response.
  final int statusCode;

  /// The HTTP status code for this response.
  final String? statusMessage;

  /// Optional description of what the request is supposed to do.
  final String? step;

  HttpResponse({
    required this.data,
    required this.headers,
    this.isRedirect = false,
    this.persistentConnection = true,
    this.request,
    this.segment,
    required this.statusCode,
    this.statusMessage,
    this.step,
  });

  /// Factory that creates a [HttpResponse] from a [http.Response].
  factory HttpResponse.fromResponse(
    http.Response response, {
    String? segment,
    String? step,
  }) {
    return HttpResponse(
      data: jsonDecode(response.body),
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      request: response.request,
      segment: segment,
      statusCode: response.statusCode,
      statusMessage: response.reasonPhrase,
      step: step,
    );
  }

  @override
  /// Returns a string representation of this object.
  String toString() {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return '''
[ HttpResponse ] > A HttpResponse was received!
[ HttpResponse ] - Method          | ${request?.method.toUpperCase()}
[ HttpResponse ] - Base URL        | ${request?.url.origin}
[ HttpResponse ] - Endpoint        | ${request?.url.path}
[ HttpResponse ] - Status Code     | $statusCode
[ HttpResponse ] - Status Message  | $statusMessage
[ HttpResponse ] - Headers         | ${encoder.convert(headers)}
[ HttpResponse ] - Data            | ${encoder.convert(data)}
[ HttpResponse ] - Segment         | $segment
[ HttpResponse ] - Step            | $step
[ HttpResponse ] -----------------------------------------
''';
  }
}
