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

import '../entities/entities.dart' show HttpResponse;
import '../interfaces/interfaces.dart' show IHttpRefreshHandler;

/// Class that implements the methods that handle the authorization's token refreshs.
final class DefaultHttpRefreshHandler implements IHttpRefreshHandler {
  const DefaultHttpRefreshHandler();

  @override
  int get statusCode => 401;

  @override
  Future<HttpResponse> refreshTokenAndRetryRequest(
    Future<HttpResponse> Function() request,
  ) async {
    return request();
  }
}
