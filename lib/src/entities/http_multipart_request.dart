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

/// Class that represents requests with some kind of binary value in it.
final class HttpMultipartRequest extends http.MultipartRequest implements HttpBaseRequest {
  /// Optional description of the module/service that the request is supposed to hit.
  final String? segment;

  /// Optional description of what the request is supposed to do.
  final String? step;

  HttpMultipartRequest(
    super.method,
    super.url, {
    this.segment,
    this.step,
  });

  @override
  /// Returns a string representation of this object.
  String toString() {
    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return '''
[ HttpMultipartRequest ] > A HttpMultipartRequest was sent!
[ HttpMultipartRequest ] - Method           | ${method.toUpperCase()}
[ HttpMultipartRequest ] - Base URL         | ${url.origin}
[ HttpMultipartRequest ] - Endpoint         | ${url.path}
[ HttpMultipartRequest ] - Query Params     | ${encoder.convert(url.queryParameters)}
[ HttpMultipartRequest ] - Headers          | ${encoder.convert(headers)}
[ HttpMultipartRequest ] - Body             | ${encoder.convert(fields)}
[ HttpMultipartRequest ] - Files            | $files
[ HttpMultipartRequest ] - Segment          | $segment
[ HttpMultipartRequest ] - Step             | $step
[ HttpMultipartRequest ] ----------------------------------------
''';
  }
}
