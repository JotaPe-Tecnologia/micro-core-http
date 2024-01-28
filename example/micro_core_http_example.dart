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

import 'package:micro_core_http/micro_core_http.dart';

final class AppHttpAuthorizationHandler implements IHttpAuthorizationHandler {
  // Local Storage Instance

  const AppHttpAuthorizationHandler();

  // Define where to add the token
  @override
  HttpAuthorizationType get authorizationType => HttpAuthorizationType.headers;

  @override
  Future<Map<String, String>> getAuthorization() async {
    // Use Local Storage Instance to return the Authorization Token
    return {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJ1c2VybmFtZSI6IjE1NDk0NDkzNzA5IiwiZW1haWwiOiJqcDk4c21hcnRpbnNAZ21haWwuY29tIiwiaXAiOjAsImxvZ2luX3Rva2VuIjoib2trbGFlb2lxamg0N3p4bDU2bG8yIiwidHlwZSI6IkFQUCIsImlhdCI6MTcwMjk4OTIyMywiZXhwIjoxNzAyOTkyODIzfQ.pNqx0JTt9FC7xkGMHgcLZE1Ln71nTnhC-qpOXlYPfGM',
    };
  }
}

final class Repository {
  final IHttpClient api;

  const Repository(this.api);

  Future<Map<String, dynamic>> getPackagesList() async {
    try {
      // Implement the request
      final response = await api.get(
        '/packages',
        segment: 'Packages',
        step: 'Getting Packages List',
      );

      // Return the response
      return Map<String, dynamic>.from(response.data);
    } on HttpException catch (exception) {
      // Treat basic/custom Exceptions here
      if (exception is HttpExceptionUnauthorized) {
        print('User is Unauthorized!');
      }
      rethrow;
    }
  }
}

class Controller {
  final Repository _repository;

  const Controller(this._repository);

  Future<void> getPackagesList() async {
    final result = await _repository.getPackagesList();

    // Deal with the result
    print(result.toString());
  }
}

void main() {
  final options = HttpOptions(
    authorizationHandler: AppHttpAuthorizationHandler(),
    baseUrl: "https://api.jotapetecnologia.com.br",
    delayBetweenRetries: Duration(seconds: 2),
    requestTimeout: Duration(seconds: 8),
    extraRetries: 2,
    showLogs: true,
  );
  final api = HttpClient(options: options);
  final repository = Repository(api);
  final controller = Controller(repository);

  controller.getPackagesList();
}
