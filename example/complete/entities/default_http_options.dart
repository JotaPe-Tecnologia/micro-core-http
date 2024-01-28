import 'package:micro_core_http/micro_core_http.dart';

import '../overrides/http_response_handler.dart';

// * It could be created different options for each environment/feature of the app

final class DefaultHttpOptions {
  late final HttpOptions _options;
  HttpOptions get options => _options;

  DefaultHttpOptions(
    IHttpAuthorizationHandler authorizationHandler,
  ) {
    _options = HttpOptions(
      authorizationHandler: authorizationHandler,
      baseUrl: 'https://api.jotapetecnologia.com.br',
      delayBetweenRetries: const Duration(seconds: 2),
      responseHandler: HttpResponseHandler(),
      extraRetries: 2,
      requestTimeout: const Duration(seconds: 12),
      showLogs: true,
    );
  }
}
