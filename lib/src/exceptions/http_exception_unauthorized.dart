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

import 'http_known_exception.dart';

/// Class that indicate a specific scenario of an exception.
///
/// - Status Code:     401
/// - Status Message:  Unauthorized
final class HttpExceptionUnauthorized extends HttpKnownException {
  static const defaultStatusCode = 401;
  static const defaultReason = 'Unauthorized';

  const HttpExceptionUnauthorized({
    super.request,
    super.code = defaultStatusCode,
    super.reason = defaultReason,
    super.statusMessage,
  });
}
