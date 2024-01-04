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

import '../entities/http_request.dart';
import '../exceptions/http_exception_request_timeout.dart';

/// Extension of [http.BaseClient] that throws an [HttpTimeoutException] if enough time passes without getting a response.
///
/// Example:
/// ```dart
/// import 'package:http/http.dart' as http;
///
/// var client = HttpTimeoutClient(
///   http.Client(),
///   timeout: const Duration(seconds: 30),
///   customTimeoutMessage: 'After 30 seconds there was no response from the host!',
/// );
/// ```
final class HttpTimeoutClient extends http.BaseClient {
  final http.Client _inner;
  final Duration timeout;
  final String? customTimeoutMessage;

  HttpTimeoutClient(
    this._inner,
    this.timeout, {
    this.customTimeoutMessage,
  });

  String get timeoutDefaultMessage {
    return (customTimeoutMessage?.isNotEmpty ?? false) ? customTimeoutMessage! : 'After ${timeout.inSeconds} seconds there was no response from the host!';
  }

  @override
  close() {
    _inner.close();
    super.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return _inner.send(request).timeout(
      timeout,
      onTimeout: () {
        throw HttpExceptionRequestTimeout(
          request: HttpRequest.fromBaseRequest(request),
          statusMessage: timeoutDefaultMessage,
        );
      },
    );
  }
}
