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

import '../entities/entities.dart' show HttpBaseRequest, HttpOptions;

/// Class to implement the methods that handle requests.
abstract base class IHttpRequestHandler {
  const IHttpRequestHandler();

  /// Method that prints the [HttpBaseRequest] on terminal if the [HttpOptions.showLogs] is true.
  void logRequest(HttpBaseRequest request);

  /// Method that runs when an request is sent.
  void onRequest(HttpBaseRequest request);
}
