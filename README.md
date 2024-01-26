## micro_core_http

![License](https://img.shields.io/github/license/JotaPe-Tecnologia/micro-core-http?logo=apache&logoColor=%23D22128&label=License&labelColor=%23FFFFFF&color=%23D22128)
![Package Version](https://img.shields.io/pub/v/micro_core_http?logo=dart&logoColor=%230175C2&label=Version&labelColor=%23FFFFFF&color=%230175C2)
![Package Points](https://img.shields.io/pub/points/micro_core_http?logo=dart&logoColor=%230175C2&label=Points&labelColor=%23FFFFFF&color=%230175C2)
![Coverage](https://img.shields.io/codecov/c/github/JotaPe-Tecnologia/micro-core-http?logo=codecov&logoColor=%23F01F7A&label=Coverage&labelColor=%23FFFFFF&color=%23F01F7A)

---

## This package is a wrapper of the http package with a handful of features out of the box.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅    |

## Features

-   Basic HTTP Requests (DELETE, GET, PATCH, POST, PUT)
-   Request's Authorization and Logging can be easily implemented and in an organized way
-   Retry Requests setting number of retries and delay between retries
-   Refresh the authorization tokens implementing the interceptor for that.

## Coming Soon

-   Download Request passing the path of the file to be downloaded to
-   Improvements on Retry Request Flow
-   Improvements on Refresh Token Interceptor to make easier to implement

## Usage

### Basic Usage

```dart
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
```

### Complete Usage

```dart
print('dart code');
```
