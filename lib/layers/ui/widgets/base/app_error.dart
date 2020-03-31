import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/locale/app_localizations.dart';

class AppErrorWidget extends StatelessWidget {
  final Object exception;

  const AppErrorWidget(this.exception, {Key key}) : super(key: key);

  bool _diagnostic(BuildContext context) =>
      AppConfig.of(context).config.diagnostic;

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getMessage(context);

    return DefaultTextStyle(
      style: AppThemes.materialAppTheme().primaryTextTheme.body1,
      child: Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        color: Colors.red,
        child: Text(
          _diagnostic(context) ? 'ERROR: $errorMessage' : errorMessage,
          style: TextStyle(
            color: Colors.white,
            fontWeight: NamedFontWeight.medium,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  String _getMessage(BuildContext context) {
    if (_diagnostic(context)) {
      final message = _getErrorMessage(context, exception);
      final diagnostic = _getDiagnosticMessage(exception);

      return '$message\n$diagnostic'.trim();
    } else {
      return _getErrorMessage(context, exception).trim();
    }
  }

  String _getErrorMessage(BuildContext context, Object exception) {
    if (exception is LocalizeMessageException) {
      if (exception.localizedMessage != null) {
        return exception.localizedMessage.localize(context);
      } else {
        return exception.message;
      }
    } else {
      return AppLocalizations.of(context).unexpectedError;
    }
  }

  String _getDiagnosticMessage(Object exception) {
    if (exception is DiagnosticMessageException &&
        exception.diagnosticMessage != null) {
      return 'DIAGNOSTIC MESSAGE:\n${exception.diagnosticMessage}';
    } else {
      return 'DIAGNOSTIC MESSAGE:\n$exception';
    }
  }
}
