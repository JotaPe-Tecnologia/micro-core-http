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

import '../entities/entities.dart' show HttpRequest;
import 'http_known_exception.dart';

/// Class that represents a specific scenario of an exception.
///
/// - Status Code:     404
/// - Status Message:  Not Found
final class HttpExceptionNotFound extends HttpKnownException {
  /// Status Code of an HTTP response.
  static const defaultStatusCode = 404;

  /// Status Message of and HTTP response exception.
  static const defaultReason = 'Not Found';

  const HttpExceptionNotFound({
    super.request,
    super.code = defaultStatusCode,
    super.reason = defaultReason,
    String? description,
  }) : super(
          description: description != null ? " $description" : "",
        );
  
  @override
  HttpExceptionNotFound copyWith({
    int? code,
    String? description,
    String? reason,
    HttpRequest? request,
  }) {
    return HttpExceptionNotFound(
      code: code ?? defaultStatusCode, 
      description: description,
      reason: reason ?? defaultReason,
      request: request,
    );
  }
}
