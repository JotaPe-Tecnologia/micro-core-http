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

import '../entities/entities.dart' show HttpOptions;

/// Class to implement the methods that handle errors.
abstract interface class IHttpErrorHandler {
  const IHttpErrorHandler();

  /// Method that prints the [Error] on terminal if the [HttpOptions.showLogs] is true.
  void logError(Error error, StackTrace stackTrace);

  /// Method that runs when an error occurs.
  ///
  /// The default behavior is to print on the terminal all the error's data.
  void onError(Error error, StackTrace stackTrace);
}
