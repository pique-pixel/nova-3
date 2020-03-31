import 'package:flutter/widgets.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/locale/localized_string.dart';

class FormsState {
  final Map<String, AppFormFieldState> fieldStates;

  // NOTE(Andrey): removed widget, but still save state for future appearing
  final Map<String, AppFormFieldState> removedFieldStates;

  FormsState({
    this.fieldStates = const {},
    this.removedFieldStates = const {},
  });

  FormsState copyWith({
    Map<String, AppFormFieldState> fieldStates,
    Map<String, AppFormFieldState> removedFieldStates,
  }) {
    return FormsState(
      fieldStates: fieldStates ?? this.fieldStates,
      removedFieldStates: removedFieldStates ?? this.removedFieldStates,
    );
  }
}

class AppFormFieldState<T> {
  final FormValue<T> value;
  final FocusNode focusNode;
  final Optional<LocalizedString> errorMessage;
  final bool isEnabled;
  final List<Validator> validators;
  final Offset offset;

  AppFormFieldState({
    this.focusNode,
    this.errorMessage = const Optional.empty(),
    this.isEnabled = true,
    this.value,
    this.validators = const [],
    this.offset = const Offset(0.0, 0.0),
  })  : assert(focusNode != null),
        assert(errorMessage != null),
        assert(isEnabled != null),
        assert(value != null),
        assert(validators != null);

  @override
  String toString() => '$AppFormFieldState<$T>(value: $value, '
      'errorMessage: $errorMessage, isEnabled: $isEnabled, '
      'validators: $validators)';

  AppFormFieldState copyWith({
    FocusNode focusNode,
    FormValue<T> value,
    Optional<LocalizedString> errorMessage,
    bool isEnabled,
    List<Validator> validators,
    Offset offset,
  }) {
    return AppFormFieldState(
      focusNode: focusNode ?? this.focusNode,
      value: value ?? this.value,
      errorMessage: errorMessage ?? this.errorMessage,
      isEnabled: isEnabled ?? this.isEnabled,
      validators: validators ?? this.validators,
      offset: offset ?? this.offset,
    );
  }
}
