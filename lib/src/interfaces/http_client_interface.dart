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

import '../entities/http_response.dart';

/// Class that represents the HTTP methods.
abstract interface class IHttpClient {
  /// Method that represents the HTTP's DELETE method.
  Future<HttpResponse> delete(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  /// Method that represents the HTTP's GET method.
  Future<HttpResponse> get(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  /// Method that represents the HTTP's HEAD method.
  Future<HttpResponse> head(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  /// Method that represents the HTTP's PUT method.
  Future<HttpResponse> put(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  /// Method that represents the HTTP's POST method.
  Future<HttpResponse> post(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });

  /// Method that represents the HTTP's PATCH method.
  Future<HttpResponse> patch(
    String endpoint, {
    bool authenticate = false,
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    String? step,
  });
}
