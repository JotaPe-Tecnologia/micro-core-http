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

import '../entities/entities.dart' show HttpBaseRequest, HttpFormData, HttpMultipartRequest, HttpRequest;
import '../interfaces/interfaces.dart' show IHttpRequestHandler;
import '../utils/constants.dart';

/// Extension of [http.BaseClient] that allows for intercepting and modifying http requests.
class HttpInterceptClient extends http.BaseClient {
  /// The client that will send the request.
  final http.Client _inner;

  /// A handler to execute its methods at the moment the request is sent.
  final IHttpRequestHandler requestHandler;

  /// The flag that will define if the [IHttpRequestHandler] should print the request on terminal.
  final bool showLogs;

  HttpInterceptClient(
    this._inner,
    this.requestHandler, {
    this.showLogs = false,
  });

  @override
  close() {
    _inner.close();
    super.close();
  }

  /// Method that creates the request.
  HttpBaseRequest createRequest(
    String method,
    Uri url, {
    Object? body,
    Encoding? encoding,
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    late final HttpBaseRequest request;

    // It will send a [HttpMultipartRequest] if the body is [HttpFormData]
    if (body is HttpFormData) {
      final multipartRequest = HttpMultipartRequest(
        method,
        url,
        segment: segment,
        step: step,
      );

      // Adding base headers
      multipartRequest.headers.addAll(Constants.formDataHeaders);

      // Adding fields
      multipartRequest.fields.addAll((body).fields);

      // Adding files
      multipartRequest.files.addAll((body).files);

      request = multipartRequest;
    } else {
      // It will send a [HttpRequest]
      final httpRequest = HttpRequest(
        method,
        url,
        segment: segment,
        step: step,
      );

      // Adding base headers
      httpRequest.headers.addAll(Constants.applicationJsonHeaders);

      // Adding custom body
      if (body != null) {
        if (body is String || body is List || body is Map) {
          httpRequest.body = jsonEncode(body);
        } else {
          throw ArgumentError(
            '[ ArgumentError ] > Invalid Request Body "${body.toString()}".',
          );
        }
      }

      request = httpRequest;
    }

    // Adding custom headers
    if (headers != null) request.headers.addAll(headers);

    return request;
  }

  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest request,
  ) async {
    return _inner.send(request);
  }

  /// Method that sends the request.
  Future<http.Response> sendUnstreamed(HttpBaseRequest request) async {
    // Logging request
    if (showLogs) {
      requestHandler.logRequest(request);
    }

    // Custom onRequest method from the [IHttpRequestHandler]
    requestHandler.onRequest(request);

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
    final request = createRequest(
      'DELETE',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
  }

  @override
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = createRequest(
      'GET',
      url,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
  }

  @override
  Future<http.Response> head(
    Uri url, {
    Map<String, String>? headers,
    String? segment,
    String? step,
  }) {
    final request = createRequest(
      'HEAD',
      url,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
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
    final request = createRequest(
      'PATCH',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
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
    final request = createRequest(
      'POST',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
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
    final request = createRequest(
      'PUT',
      url,
      body: body,
      encoding: encoding,
      headers: headers,
      segment: segment,
      step: step,
    );
    return sendUnstreamed(request);
  }
}
