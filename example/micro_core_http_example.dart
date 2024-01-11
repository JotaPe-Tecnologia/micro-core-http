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

import 'dart:developer';

import 'package:micro_core_http/micro_core_http.dart';

final class AppHttpAuthorizationHandler implements IHttpAuthorizationHandler {
  const AppHttpAuthorizationHandler(
      // Local Storage Instance
      );

  @override
  HttpAuthorizationType get authorizationType => HttpAuthorizationType.headers;

  @override
  Future<Map<String, String>> getAuthorization() async {
    // Local Storage Search

    return {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMiLCJ1c2VybmFtZSI6IjE1NDk0NDkzNzA5IiwiZW1haWwiOiJqcDk4c21hcnRpbnNAZ21haWwuY29tIiwiaXAiOjAsImxvZ2luX3Rva2VuIjoib2trbGFlb2lxamg0N3p4bDU2bG8yIiwidHlwZSI6IkFQUCIsImlhdCI6MTcwMjk4OTIyMywiZXhwIjoxNzAyOTkyODIzfQ.pNqx0JTt9FC7xkGMHgcLZE1Ln71nTnhC-qpOXlYPfGM',
    };
  }
}

/// Treat default Exceptions
void onException(HttpException exception, StackTrace stackTrace) {
  if (exception is HttpExceptionUnauthorized) {
    // Treat Unauthorized Exception
  }
}

final options = HttpOptions(
  authorizationHandler: AppHttpAuthorizationHandler(),
  baseUrl: "https://api-dev.app.zarppi.com.br",
  delayBetweenRetries: Duration(seconds: 2),
  requestTimeout: Duration(seconds: 8),
  extraRetries: 2,
  showLogs: true,
);

final class Repository {
  final IHttpClient api;

  const Repository(this.api);

  Future<Map<String, dynamic>> getAppVersion() async {
    try {
      final response = await api.get(
        '/settings/app-version',
        segment: 'Settings',
        step: 'Getting App Version',
      );
      return Map<String, dynamic>.from(response.data);
    } on HttpException catch (exception) {
      // Treat custom exceptions here
      if (exception is HttpExceptionUnauthorized) {
        print('lala');
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    try {
      final response = await api.post(
        '/auth/login',
        body: {
          "username": "15494493709",
          "password": "Senh@123",
        },
        segment: 'Authentication',
        step: 'Sign User in',
      );
      return Map<String, dynamic>.from(response.data);
    } on Exception catch (exception) {
      log('Handle Exception - $exception');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      final response = await api.get(
        '/users',
        authenticate: true,
        segment: 'Users',
        step: 'Getting User Data',
      );
      return Map<String, dynamic>.from(response.data);
    } on Exception catch (exception) {
      log('Handle Exception - $exception');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patchUserData(
    String phone,
  ) async {
    try {
      final response = await api.patch(
        '/users',
        authenticate: true,
        body: {
          'telephone_2': phone,
        },
        segment: 'Users',
        step: 'Updating User Data',
      );
      return Map<String, dynamic>.from(response.data);
    } on Exception catch (exception) {
      log('Handle Exception - $exception');
      rethrow;
    }
  }
}

class Controller {
  final Repository _repository;

  const Controller(this._repository);

  void getAppVersion() async {
    final result = await _repository.getAppVersion();

    log(
      '''
[ Controller ] > getAppVersion()
[ Controller ] - Android Min Version     | ${result['android_min_version']}
[ Controller ] - iOS Min Version         | ${result['ios_min_version']}
[ Controller ] - Android Latest Version  | ${result['android_latest_version']}
[ Controller ] - iOS Latest Version      | ${result['ios_latest_version']}
''',
    );
  }

  void getUserData() async {
    final result = await _repository.getUserData();

    log(
      '''
[ Controller ] > getUserData()
[ Controller ] - Id         | ${result['id']}
[ Controller ] - Username   | ${result['username']}
[ Controller ] - Full Name  | ${result['full_name']}
[ Controller ] - Email      | ${result['email']}
[ Controller ] - Phone      | ${result['telephone_2']}
''',
    );
  }

  void patchUserData() async {
    final result = await _repository.patchUserData(
      '21998109950',
    );

    log(
      '''
[ Controller ] > patchUserData()
[ Controller ] - Success    | ${result['success']}
[ Controller ] - Message    | ${result['message']}
''',
    );
  }

  void login() async {
    final result = await _repository.login(
      '15494493709',
      'Senh@123',
    );

    log(
      '''
[ Controller ] > login()
[ Controller ] - Access Token     | ${result['access_token']}
[ Controller ] - Refresh Token    | ${result['refresh_token']}
''',
    );
  }
}

void main() async {
  final api = HttpClient(options: options);
  final repository = Repository(api);
  final controller = Controller(repository);

  controller.getAppVersion();

  await Future.delayed(const Duration(seconds: 1));

  controller.patchUserData();

  await Future.delayed(const Duration(seconds: 1));

  controller.getUserData();

  await Future.delayed(const Duration(seconds: 1));
}
