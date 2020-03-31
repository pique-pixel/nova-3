import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/fields.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/layers/ui/colors.dart';

class BigWhiteRoundedInput extends StatelessWidget {
  final String fieldName;
  final List<Validator> validators;
  final bool obscureText;
  final bool autoFocus;
  final String placeholder;

  final inputFieldStyle = ({
    bool isFocused = false,
    bool hasError = false,
  }) =>
      TxtStyle()
        ..textColor(Colors.black)
        ..textAlign.left()
        ..fontSize(16)
        ..height(50)
        ..padding(horizontal: 15, vertical: 14)
        ..margin(horizontal: 50, vertical: 8)
        ..borderRadius(all: 10)
        ..alignment.center()
        ..background.color(Colors.white)
        ..border(
          all: 1,
          color: hasError
              ? AppColors.primaryRed
              : isFocused ? Colors.blue[600] : Colors.white,
        )
        ..animate(300, Curves.easeOut);

  final errorTextStyle = ({bool hasError = true}) => TxtStyle()
    ..fontSize(12)
    ..bold()
    ..width(150)
    ..offset(0, hasError ? 0 : -20)
    ..margin(bottom: 8, horizontal: 50)
    ..textColor(AppColors.defaultValidationError)
    ..animate(150, Curves.easeOut)
    ..height(hasError ? 20 : 0)
    ..textAlign.center()
    ..alignment.centerLeft();

  BigWhiteRoundedInput({
    Key key,
    @required this.fieldName,
    this.validators = const [],
    this.obscureText = false,
    this.autoFocus = false,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DivisionAppFormTextField(
      autoFocus: autoFocus,
      style: inputFieldStyle(),
      focusedStyle: inputFieldStyle(isFocused: true),
      errorStyle: inputFieldStyle(hasError: true),
      errorFocusedStyle: inputFieldStyle(isFocused: true, hasError: true),
      errorTextStyle: errorTextStyle(),
      errorNotPresentedTextStyle: errorTextStyle(hasError: false),
      placeholder: placeholder,
      obscureText: obscureText,
      initValue: () => StringFormValue(),
      validators: this.validators,
      fieldName: fieldName,
    );
  }
}
