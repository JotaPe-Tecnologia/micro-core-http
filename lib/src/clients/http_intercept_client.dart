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

import 'package:http/http.dart' as http;

import '../entities/http_request.dart';
import '../entities/http_response.dart';
import '../utils/constants.dart';

/// Extension of [http.BaseClient] that allows for intercepting and modifying http requests and responses.
///
/// Example:
/// ```dart
/// import 'package:http/http.dart' as http;
///
/// var client = HttpInterceptClient(
///   http.Client(),
///   onRequest: (request) {
///     print("${request.method}/${request.url}");
///   },
///   onResponse: (response) {
///     print("${request.method}/${request.url}");
///   }
/// );
/// ```
final class HttpInterceptClient extends http.BaseClient {
  final http.Client _inner;
  final bool showLogs;
  final void Function(HttpRequest)? onRequest;
  final void Function(HttpResponse)? onResponse;

  HttpInterceptClient(
    this._inner, {
    this.showLogs = false,
    this.onRequest,
    this.onResponse,
  });

  @override
  close() {
    _inner.close();
    super.close();
  }

  HttpRequest _createRequest(
    String method,
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = HttpRequest(
      method,
      url,
      segment: segment,
      step: step,
    );

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      // TODO: a
      // if (body is String) {
      //   request.body = body;
      //   request.headers.addAll(Constants.applicationJsonHeaders);
      // } else if (body is List) {
      //   request.bodyBytes = body.cast<int>();
      //   request.headers.addAll(Constants.applicationJsonHeaders);
      // } else if (body is Map) {
      //   request.bodyFields = body.cast<String, String>();
      //   request.headers.addAll(Constants.applicationJsonHeaders);
      // } else {
      //   throw ArgumentError(
      //     '[ ArgumentError ] > Invalid Request Body "${body.toString()}".',
      //   );
      // }
      request.body = jsonEncode(body);
      request.headers.addAll(Constants.applicationJsonHeaders);
    }

    return request;
  }

  Future<http.Response> _sendUnstreamed(HttpRequest request) async {
    if (showLogs) {
      print(request);
    }

    onRequest?.call(request);

    final response = await http.Response.fromStream(
      await send(request),
    );

    return response;
  }

  @override
  Future<http.Response> delete(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'DELETE',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'GET',
      url,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.Response> head(
    Uri url, {
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'HEAD',
      url,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.Response> post(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'POST',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.Response> put(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'PUT',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.Response> patch(
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = _createRequest(
      'PATCH',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return _sendUnstreamed(request);
  }

  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest request,
  ) async {
    return _inner.send(request);
  }
}
