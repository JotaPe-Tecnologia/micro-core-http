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

part of '../interceptors/retry_interceptor.dart';

/// Extension to track the number of request attempts on [dio.RequestOptions].
extension RequestAttemptExtension on dio.RequestOptions {
  /// The number of times the request has been attempted.
  int get attempt => extra['attempt'] ?? 0;

  /// Increments the number of times the request has been attempted.
  void incrementAttempt() => extra['attempt'] = attempt + 1;
}
