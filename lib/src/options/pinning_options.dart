import 'dart:io' as io;

import 'package:flutter/services.dart';

/// Class that handles the http pinning.
final class PinningOptions {
  /// List of certificates path.
  final List<String> certificatesPath = [];

  /// List of certificates as bytes.
  final List<ByteData> certificatesBytes = [];

  /// List of certificates as pem.
  final List<String> certificatesPem = [];

  static final _instance = PinningOptions._();
  PinningOptions._();
  factory PinningOptions() => _instance;

  /// Method that loads the certificates bytes.
  ///
  /// This method must be called in the `main` method, before [runApp]
  ///
  /// The [certificatesPath] is a list of paths to the certificates.
  /// The certificates must be in the assets folder, be added to the `pubspec.yaml`
  /// file, and the path must be relative to the assets folder.
  /// The certificates must be in a `.pem` format.
  ///
  /// When downloading the certificate from the server, it will be in a `.crt` or `.cer` format.
  /// To convert it to `.pem`, you can use the following command:
  ///
  /// ```bash
  /// openssl x509 -in certificate.crt -out certificate.pem -outform PEM
  /// ```
  Future<void> loadCertificateBytes({List<String>? certificatesPath}) async {
    if (certificatesPath != null && certificatesPath.isNotEmpty) {
      this.certificatesBytes.clear();
      this.certificatesPath.clear();
      this.certificatesPem.clear();
      this.certificatesPath.addAll(certificatesPath);
    }

    // Certificates as Bytes
    final certificatesBytes = await Future.wait(
      this.certificatesPath.map((path) => rootBundle.load(path)),
    );
    this.certificatesBytes.addAll(certificatesBytes);

    // Certificates as String (PEM)
    final certificatesPem = certificatesBytes.map(
      (certificate) => String.fromCharCodes(
        certificate.buffer.asUint8List(),
      ).replaceAll(RegExp(r'/(\r\n)+|(\r)+|(\n)+/g'), ''),
    );
    this.certificatesPem.addAll(certificatesPem);
  }

  /// Method that creates the http client with the security context.
  io.HttpClient createHttpClient() {
    // Creating security context
    final securityContext = io.SecurityContext.defaultContext;

    // Adding certificates to security context
    certificatesBytes.map(
      (certificate) => securityContext.setTrustedCertificatesBytes(
        certificate.buffer.asUint8List(),
      ),
    );

    // Creating client with security context
    return io.HttpClient(context: securityContext);
  }

  /// Method that validates the certificate.
  bool validateCertificate(
    io.X509Certificate? certificate,
    String host,
    int port,
  ) {
    if (certificate == null) return false;
    final serverCertificateAsString = certificate.pem.replaceAll(
      RegExp(r'/(\r\n)+|(\r)+|(\n)+/g'),
      '',
    );
    return certificatesPem.contains(serverCertificateAsString);
  }
}
