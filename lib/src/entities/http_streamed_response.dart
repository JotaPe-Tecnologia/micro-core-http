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

import 'package:http/http.dart' as http;

import 'http_request.dart';

/// Class that extends [http.StreamedResponse] to wrap the library.
final class HttpStreamedResponse extends http.StreamedResponse {
  HttpStreamedResponse(
    super.stream,
    super.statusCode, {
    super.contentLength,
    HttpRequest? request,
    super.headers = const {},
    super.isRedirect = false,
    super.persistentConnection = true,
    super.reasonPhrase,
  }) : super(request: request);
}