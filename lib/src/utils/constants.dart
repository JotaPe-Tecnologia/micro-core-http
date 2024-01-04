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

/// A class to store default values to use across the package.
abstract base class Constants {
  /// The amount of time that the client will wait before retries a request.
  static const delayBetweenRetries = Duration(seconds: 1);

  /// The amount of time that the client will wait for a response.
  static const requestTimeout = Duration(seconds: 10);

  /// The amount of extra retries of a failing request.
  ///
  /// If the expected behavior is to request 3 times before consider
  /// a failure, just assing 2 extra retries, since the package will
  /// always request the first time.
  static const extraRetries = 0;

  /// The flag that activates all the out of the box logs.
  ///
  /// It will log all the requests, responses, exceptions and errors.
  static const showLogs = false;

  // TODO
  static const applicationJsonHeaders = {
    'accept': '*/*',
    'content-type': 'application/json',
  };
  static const formUrlencodedHeaders = {
    'accept': '*/*',
    'content-type': 'application/x-www-form-urlencoded',
  };
  static const formDataHeaders = {
    'accept': '*/*',
    'content-type': 'multipart/form-data',
  };
}
