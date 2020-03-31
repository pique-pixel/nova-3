import 'package:flutter/widgets.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/locale/app_localizations.dart';
import 'package:rp_mobile/locale/localized_string.dart';

import 'data.dart';

abstract class Validator {
  bool isValid<T>(FormValue<T> value);

  Optional<LocalizedString> getValidationMessage<T>(FormValue<T> value);
}

class RequiredValidator implements Validator {
  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if (value.isEmpty()) {
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).validationRequiredError),
      );
    } else {
      return Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    return !value.isEmpty();
  }
}
class PasswordValidator implements Validator {
  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if(value == null){
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).validationRequiredError),
      );
    }
    else if(value.isEmpty()){
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).validationRequiredError),
      );
    }
    if (value.length() < 8) {
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).minPasswordValidationError),
      );
    } else {
      return Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    var isValid =  !value.isEmpty() && value.length() >= 8;
    return isValid;
  }
}

class EmailValidator implements Validator {
  @override
  Optional<LocalizedString> getValidationMessage<T>(
    FormValue<T> value,
  ) {
    if(value == null){
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).validationRequiredError),
      );
    }
     else if(value.isEmpty()){
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).validationRequiredError),
      );
    }
    else if(!validateCredentials(value.data as String)){
      return Optional.of(
        LocalizedString(
            (context) => AppLocalizations.of(context).emailInvalidError),
      );
    }
     else {
      return Optional.empty();
    }
  }

  @override
  bool isValid<T>(FormValue<T> value) {
    var isValid =  !value.isEmpty() &&  validateCredentials(value.data as String);
    return isValid;
  }
}

bool validateCredentials(String email,) {
 

  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  var status = regExp.hasMatch(email);
  if (!status) {
    return false;
  }
  return true;
}
