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

/// Class of configuration options to throw a timeout exception during a HTTP request.
final class TimeoutOptions {
  /// The timeout duration to connect to the server.
  final Duration connectTimeout;

  /// The timeout duration to receive data from the server.
  final Duration receiveTimeout;

  /// The timeout duration to send data to the server.
  final Duration sendTimeout;

  const TimeoutOptions({
    this.connectTimeout = const Duration(seconds: 3),
    this.receiveTimeout = const Duration(seconds: 12),
    this.sendTimeout = const Duration(seconds: 9),
  });
}
