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

import '../entities/entities.dart' show HttpRequest;
import '../exceptions/exceptions.dart' show HttpExceptionRequestTimeout;

/// Extension of [http.BaseClient] that throws an [HttpExceptionRequestTimeout] if enough time passes without getting a response.
final class HttpTimeoutClient extends http.BaseClient {
  /// The client that will send the request.
  final http.Client _inner;

  /// The timeout duration that will determine when to throw the [HttpExceptionRequestTimeout]. 
  final Duration timeout;

  /// An override of the default message of a [HttpExceptionRequestTimeout].
  final String? customTimeoutMessage;

  HttpTimeoutClient(
    this._inner,
    this.timeout, {
    this.customTimeoutMessage,
  });

  /// Getter of the timeout message.
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
          description: timeoutDefaultMessage,
        );
      },
    );
  }
}
