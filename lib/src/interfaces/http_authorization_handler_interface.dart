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

import '../enums/enums.dart' show HttpAuthorizationType;

/// Class to implement the authorization needed to your project.
abstract interface class IHttpAuthorizationHandler {
  /// Getter of [HttpAuthorizationType].
  ///
  /// This will define where the authorization will be inserted on the request.
  ///
  /// There are different types for this getter, such as:
  ///
  /// - [HttpAuthorizationType.headers] > Set this and the return of the
  /// [getAuthorization] method will be inserted on the header of the request.
  /// - [HttpAuthorizationType.noAuthorization] > Set this and the return of the
  /// [getAuthorization] method will not be inserted on any part of the request.
  /// - [HttpAuthorizationType.queryParams] > Set this and the return of the
  /// [getAuthorization] method will be inserted on the query params of the request.
  ///
  /// The default value is [HttpAuthorizationType.noAuthorization].
  HttpAuthorizationType get authorizationType;

  /// Method that returns the authorization needed on your project.
  ///
  /// This will be inserted depending on the [authorizationType] defined.
  ///
  /// You can use this method to get the token from a local storage. eg.:
  ///
  /// ```dart
  /// Future<Map<String, String>> getAuthorization() async {
  ///   final _token = await _getTokenFromLocalStorage();
  ///   return {"Authorization": "Bearer $_token"};
  /// }
  /// ```
  ///
  /// The default value is an empty [Map].
  Future<Map<String, String>> getAuthorization();
}
