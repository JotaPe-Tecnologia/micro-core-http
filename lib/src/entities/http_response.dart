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

import 'package:dio/dio.dart' as dio;

/// Class that represents the response of a HTTP's request.
final class HttpResponse<T> extends dio.Response<T> {
  /// Optional description of the module/service that the request is supposed to hit.
  final String? segment;

  /// Optional description of what the request is supposed to do.
  final String? step;

  HttpResponse({
    required super.requestOptions,
    super.data,
    super.statusCode,
    super.statusMessage,
    super.isRedirect = false,
    super.redirects = const [],
    Map<String, dynamic>? extra,
    dio.Headers? headers,
    this.segment,
    this.step,
  });

  /// Factory that creates a [HttpResponse] from a [dio.Response].
  factory HttpResponse.fromDioResponse(dio.Response<T> response) {
    return HttpResponse<T>(
      requestOptions: response.requestOptions,
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      isRedirect: response.isRedirect,
      redirects: response.redirects,
      extra: response.extra,
      headers: response.headers,
      segment: response.requestOptions.extra['segment'],
      step: response.requestOptions.extra['step'],
    );
  }
}
