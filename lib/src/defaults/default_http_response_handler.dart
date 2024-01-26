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
import '../interfaces/http_response_handler_interface.dart';

/// Class that implements the methods that handle responses.
final class DefaultHttpResponseHandler implements IHttpResponseHandler {
  const DefaultHttpResponseHandler();

  @override
  void logResponse(HttpResponse response) => print(response);

  @override
  void onResponse(HttpResponse response) {}
}
