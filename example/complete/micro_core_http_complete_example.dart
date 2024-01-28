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

import 'entities/default_http_options.dart';
import 'http_adapter.dart';
import 'interfaces/http_adapter_interface.dart';
import 'overrides/http_authorization_handler.dart';

final class Repository {
  final IHttpAdapter api;

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
  final authorizationHandler = AppHttpAuthorizationHandler();
  final defaultOptions = DefaultHttpOptions(authorizationHandler);
  final api = HttpAdapter(defaultOptions.options);
  final repository = Repository(api);
  final controller = Controller(repository);

  controller.getPackagesList();
}
