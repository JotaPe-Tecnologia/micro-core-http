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

/// Enum to define where the authorization will be inserted on the request.
///
/// There are different types for this getter, such as:
///
/// - [HttpAuthorizationType.headers]
/// - [HttpAuthorizationType.noAuthorization] > Set this and the return of the
/// [getAuthorization] method will not be inserted on any part of the request.
/// - [HttpAuthorizationType.queryParams] > Set this and the return of the
/// [getAuthorization] method will be inserted on the query params of the request.
enum HttpAuthorizationType {
  /// Set this if the request needs authorization on the header of the request.
  headers,

  /// Set this if the request doesn't need any type of authorization on the request.
  noAuthorization,

  /// Set this if the request needs authorization on the query params of the request.
  queryParams;

  /// Getter to know if the [HttpAuthorizationType] is [HttpAuthorizationType.headers].
  bool get isHeaders => this == HttpAuthorizationType.headers;

  /// Getter to know if the [HttpAuthorizationType] is [HttpAuthorizationType.queryParams].
  bool get isQueryParams => this == HttpAuthorizationType.queryParams;

  /// Getter to know if the [HttpAuthorizationType] is [HttpAuthorizationType.noAuthorization].
  bool get isNoAuthorization => this == HttpAuthorizationType.noAuthorization;
}
