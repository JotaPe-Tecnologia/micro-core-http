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

import 'http_base_request.dart';

/// Class that represents basic requests.
final class HttpRequest extends http.Request implements HttpBaseRequest {
  /// Optional description of the module/service that the request is supposed to hit.
  final String? segment;

  /// Optional description of what the request is supposed to do.
  final String? step;

  HttpRequest(
    super.method,
    super.url, {
    this.segment,
    this.step,
  });

  /// Factory that creates a [HttpRequest] from a [http.BaseRequest].
  factory HttpRequest.fromBaseRequest(
    http.BaseRequest request, {
    String? segment,
    String? step,
  }) {
    return HttpRequest(
      request.method.toUpperCase(),
      request.url,
      segment: segment,
      step: step,
    );
  }

  @override
  /// Returns a string representation of this object.
  String toString() {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return '''
[ HttpRequest ] > A HttpRequest was sent!
[ HttpRequest ] - Method           | ${method.toUpperCase()}
[ HttpRequest ] - Base URL         | ${url.origin}
[ HttpRequest ] - Endpoint         | ${url.path}
[ HttpRequest ] - Query Params     | ${encoder.convert(url.queryParameters)}
[ HttpRequest ] - Headers          | ${encoder.convert(headers)}
[ HttpRequest ] - Body             | ${body.isNotEmpty ? encoder.convert(jsonDecode(body)) : null}
[ HttpRequest ] - Segment          | $segment
[ HttpRequest ] - Step             | $step
[ HttpRequest ] ----------------------------------------
''';
  }
}
