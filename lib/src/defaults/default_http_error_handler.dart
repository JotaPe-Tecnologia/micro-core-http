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

import '../interfaces/http_error_handler_interface.dart';

/// Class that implements the methods that handle errors.
final class DefaultHttpErrorHandler implements IHttpErrorHandler {
  const DefaultHttpErrorHandler();

  @override
  void logError(Error error, StackTrace stackTrace) {
    print('''
[ ${error.runtimeType} ] > A ${error.runtimeType} was thrown!
[ ${error.runtimeType} ] - Type           | ${error.runtimeType}
[ ${error.runtimeType} ] - Error          | ${error.toString()}
[ ${error.runtimeType} ] - StackTrace     | $stackTrace
[ ${error.runtimeType} ] -----------------------------------------
''');
  }

  @override
  void onError(Error error, StackTrace stackTrace) {}
}
