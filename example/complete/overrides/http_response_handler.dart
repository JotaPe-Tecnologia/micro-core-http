import 'package:micro_core_http/micro_core_http.dart';

final class HttpResponseHandler implements IHttpResponseHandler {
  @override
  void logResponse(HttpResponse response) {
    if (response.statusCode > 199 && response.statusCode < 300) {
      // return Logger.logSuccess(response.toString());
    }

    // return Logger.logWarning(response.toString());
  }

  @override
  void onResponse(HttpResponse response) {}
}
