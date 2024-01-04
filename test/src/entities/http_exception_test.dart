// // Copyright 2024 JotapeTecnologia

// // Licensed under the Apache License, Version 2.0 (the "License");
// // you may not use this file except in compliance with the License.
// // You may obtain a copy of the License at

// //     http://www.apache.org/licenses/LICENSE-2.0

// // Unless required by applicable law or agreed to in writing, software
// // distributed under the License is distributed on an "AS IS" BASIS,
// // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// // See the License for the specific language governing permissions and
// // limitations under the License.

// import 'package:micro_core_http/src/entities/http_exception.dart';
// import 'package:test/test.dart';

// void main() {
//   group(
//     'HttpException - Status Code',
//     () {
//       const statusMessage = 'statusMessage';
//       const type = HttpExceptionType.noAuthorization;

//       test(
//         '| Should thow an AssertionError when statusCode is lower than 400',
//         () {
//           // Arrange
//           final statusCode = 399;

//           try {
//             // Act
//             HttpException(
//               statusCode: statusCode,
//               statusMessage: statusMessage,
//               type: type,
//             );
//           } catch (error) {
//             // Assert
//             expect(error, isA<AssertionError>());
//           }
//         },
//       );

//       test(
//         '| Should thow an AssertionError when statusCode is greater than 599',
//         () {
//           // Arrange
//           final statusCode = 600;

//           try {
//             // Act
//             HttpException(
//               statusCode: statusCode,
//               statusMessage: statusMessage,
//               type: type,
//             );
//           } catch (error) {
//             // Assert
//             expect(error, isA<AssertionError>());
//           }
//         },
//       );

//       test(
//         '| Should create an instance of HttpException when statusCode is between [400, 599]',
//         () {
//           // Arrange
//           final statusCode = 404;

//           // Act
//           final exception = HttpException(
//             statusCode: statusCode,
//             statusMessage: statusMessage,
//             type: type,
//           );

//           // Assert
//           expect(exception.statusCode, equals(statusCode));
//         },
//       );
//     },
//   );
// }
