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
abstract interface class HttpClient {
  /// Method that represents the HTTP's DELETE method.
  Future<HttpResponse<T>> delete<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });

  /// Method that represents the HTTP's GET method to download a file.
  Future<HttpResponse> download(
    String endpoint,
    String pathToSave, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });

  /// Method that represents the HTTP's GET method.
  Future<HttpResponse<T>> get<T>(
    String endpoint, {
    bool authenticate = false,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });

  /// Method that represents the HTTP's PATCH method.
  Future<HttpResponse<T>> patch<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });

  /// Method that represents the HTTP's POST method.
  Future<HttpResponse<T>> post<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });

  /// Method that represents the HTTP's PUT method.
  Future<HttpResponse<T>> put<T>(
    String endpoint, {
    bool authenticate = false,
    Object? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    String? replaceBaseUrl,
    String? segment,
    bool? showLogs,
    String? step,
  });
}
