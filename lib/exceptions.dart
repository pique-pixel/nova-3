import 'package:rp_mobile/locale/localized_string.dart';

class SchemeConsistencyException implements Exception {
  final String message;

  SchemeConsistencyException([this.message = 'Schemes consistency error']);

  String toString() {
    if (message == null) return '$SchemeConsistencyException';
    return '$SchemeConsistencyException: $message';
  }
}

abstract class DiagnosticMessageException implements Exception {
  String get diagnosticMessage;
}

abstract class LocalizeMessageException implements Exception {
  String get message;

  LocalizedString get localizedMessage;
}
