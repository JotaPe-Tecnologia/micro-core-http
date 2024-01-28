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
