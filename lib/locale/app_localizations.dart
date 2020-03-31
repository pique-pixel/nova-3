import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rp_mobile/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    debugPrint("local: " + locale.toString());

    return initializeMessages(localeName).then((bool _) {
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'RussPass',
      name: 'title',
      desc: 'The application title',
    );
  }

  String get login {
    return Intl.message(
      'Войти',
      name: 'login',
    );
  }

  String get signUp {
    return Intl.message(
      'Регистрация',
      name: 'sign_up',
    );
  }

  String get faq {
    return Intl.message(
      'FAQ',
      name: 'faq',
    );
  }

  String get back {
    return Intl.message(
      'назад',
      name: 'back',
    );
  }

  String get faqTitle {
    return Intl.message(
      'Пожалуйста, позвоните или напишите нам, мы обязательно Вам поможем!',
      name: 'faq_title',
    );
  }

  String get supportAdd {
    return Intl.message(
      'Подать обращение',
      name: 'support_add',
    );
  }

  // Errors

  String get unexpectedError {
    return Intl.message('Неожиданная ошибка', name: 'unexpected_error');
  }

  // Validation errors

  String get validationRequiredError {
    return Intl.message(
      'This field is required',
      name: 'required_error',
    );
  }

  // Min character password validation errors

  String get minPasswordValidationError {
    return Intl.message(
      'Пароль должен состоять из 8 и более символов',
      name: 'min_required_error',
    );
  }

  String get emailInvalidError {
    return Intl.message(
      'Неверный адрес электронной почты',
      name: 'invalid_emial',
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
