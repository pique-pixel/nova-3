import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/locale/localized_string.dart';

@immutable
abstract class FormsEvent {}

class OnAddInput extends FormsEvent {
  final String fieldName;
  final FormValue value;
  final List<Validator> validators;

  OnAddInput(this.fieldName, this.value, this.validators);
}

// NOTE(Andrey): We will sort widgets by vertical offset
//   to focus correct widget when validation error occur
class OnUpdateInputOffset extends FormsEvent {
  final String fieldName;
  final Offset offset;

  OnUpdateInputOffset(this.fieldName, this.offset);
}

class OnRemoveInput extends FormsEvent {
  final String fieldName;
  final bool saveState;

  OnRemoveInput({
    this.fieldName,
    this.saveState = true,
  });
}

class OnSubmit extends FormsEvent {}

class OnUpdateValue<T> extends FormsEvent {
  final String fieldName;
  final FormValue<T> newValue;

  OnUpdateValue(this.fieldName, this.newValue);

  @override
  String toString() {
    return '$fieldName: $newValue';
  }
}

class OnFieldError extends FormsEvent {
  final String fieldName;
  final LocalizedString error;
  final bool requestFocus;

  OnFieldError({
    this.fieldName,
    this.error,
    this.requestFocus = true,
  })  : assert(fieldName != null),
        assert(error != null),
        assert(requestFocus != null);
}

class OnFieldClearError extends FormsEvent {
  final String fieldName;

  OnFieldClearError(this.fieldName);
}

class OnClearAllErrors extends FormsEvent {}

class OnValidateForm extends FormsEvent {}

class OnValidateField extends FormsEvent {
  final String fieldName;
  final bool requestFocusOnError;

  OnValidateField({
    this.fieldName,
    this.requestFocusOnError = true,
  })  : assert(fieldName != null),
        assert(requestFocusOnError != null);
}
