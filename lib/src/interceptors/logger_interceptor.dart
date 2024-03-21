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

import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:micro_core_logger/micro_core_logger.dart' as logger;

import '../entities/http_exception.dart';

/// A [dio.Interceptor] that logs the exceptions/erros, requests, and responses.
final class LoggerInterceptor extends dio.Interceptor {
  /// A [JsonEncoder] that indents the JSON output.
  final _encoder = const JsonEncoder.withIndent('  ');

  /// A [Logger] that logs the exceptions/erros, requests, and responses.
  final _logger = logger.Logger();

  /// Converts the [dio.FormData] to a [Map].
  Map<String, String> formDataToMap(dio.FormData formData) {
    final map = <String, String>{};
    formData.fields.map((field) => map[field.key] = field.value);
    formData.files.map((file) => map[file.key] = file.value.filename ?? 'File');
    return map;
  }

  /// Parses the body data.
  String parseBodyData(dynamic data) {
    return switch (data) {
      String() => _encoder.convert(jsonDecode(data)),
      Map() => _encoder.convert(data),
      dio.FormData() => _encoder.convert(formDataToMap(data)),
      _ => data.toString(),
    };
  }

  /// Logs the Requests.
  @override
  void onRequest(
    dio.RequestOptions options,
    dio.RequestInterceptorHandler handler,
  ) {
    if (options.extra['showLogs'] ?? false) {
      _logger.logInfo(
        '''
[ HttpRequest ] > A HttpRequest was sent!
[ HttpRequest ] - Method           | ${options.method.toUpperCase()}
[ HttpRequest ] - Base URL         | ${options.baseUrl}
[ HttpRequest ] - Endpoint         | ${options.path}
[ HttpRequest ] - Query Params     | ${_encoder.convert(options.queryParameters)}
[ HttpRequest ] - Headers          | ${_encoder.convert(options.headers)}
[ HttpRequest ] - Body             | ${parseBodyData(options.data)}
[ HttpRequest ] - Segment          | ${options.extra['segment']}
[ HttpRequest ] - Step             | ${options.extra['step']}
[ HttpRequest ] ----------------------------------------
''',
        time: DateTime.now(),
      );
    }
    return super.onRequest(options, handler);
  }

  /// Logs the Responses.
  @override
  void onResponse(
    dio.Response response,
    dio.ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.extra['showLogs'] ?? false) {
      _logger.logSuccess(
        '''
[ HttpResponse ] > A HttpResponse was received!
[ HttpResponse ] - Method          | ${response.requestOptions.method.toUpperCase()}
[ HttpResponse ] - Base URL        | ${response.requestOptions.baseUrl}
[ HttpResponse ] - Endpoint        | ${response.requestOptions.path}
[ HttpResponse ] - Status Code     | ${response.statusCode}
[ HttpResponse ] - Status Message  | ${response.statusMessage}
[ HttpResponse ] - Headers         | ${_encoder.convert(response.headers.map)}
[ HttpResponse ] - Data            | ${parseBodyData(response.data)}
[ HttpResponse ] - Segment         | ${response.requestOptions.extra['segment']}
[ HttpResponse ] - Step            | ${response.requestOptions.extra['step']}
[ HttpResponse ] -----------------------------------------
''',
        time: DateTime.now(),
      );
    }
    return super.onResponse(response, handler);
  }

  /// Logs the Exceptions/Errors.
  @override
  void onError(
    dio.DioException err,
    dio.ErrorInterceptorHandler handler,
  ) {
    if (err.requestOptions.extra['showLogs'] ?? false) {
      _logger.logError(
        '''
[ ${err.type} ] > A ${err.type} was thrown!
[ ${err.type} ] - Base URL       | ${err.requestOptions.baseUrl}
[ ${err.type} ] - Endpoint       | ${err.requestOptions.path}
[ ${err.type} ] - Query Params   | ${_encoder.convert(err.requestOptions.queryParameters)}
[ ${err.type} ] - Headers        | ${_encoder.convert(err.requestOptions.headers)}
[ ${err.type} ] - Segment        | ${err.requestOptions.extra['segment']}
[ ${err.type} ] - Step           | ${err.requestOptions.extra['step']}
[ ${err.type} ] - Status Code    | ${err.response?.statusCode}
[ ${err.type} ] - Status Message | ${err.response?.statusMessage}
[ ${err.type} ] -----------------------------------------
''',
        time: DateTime.now(),
      );
    }
    return super.onError(HttpException.fromDioException(err), handler);
  }
}
