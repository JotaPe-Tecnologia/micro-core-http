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

final class HttpResponse {
  final dynamic data;
  final Map<String, String> headers;
  final bool isRedirect;
  final bool persistentConnection;
  final http.BaseRequest? request;
  final String? segment;
  final int statusCode;
  final String? statusMessage;
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
