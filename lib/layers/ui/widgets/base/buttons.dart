import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/themes.dart';

class ThemedRaisedButton extends StatelessWidget {
  final AppButtonTheme buttonTheme;
  final VoidCallback onPressed;
  final ValueChanged<bool> onHighlightChanged;
  final ButtonTextTheme textTheme;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final Color splashColor;
  final Brightness colorBrightness;
  final double elevation;
  final double focusElevation;
  final double hoverElevation;
  final double highlightElevation;
  final double disabledElevation;
  final EdgeInsetsGeometry padding;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final FocusNode focusNode;
  final bool autofocus;
  final MaterialTapTargetSize materialTapTargetSize;
  final Duration animationDuration;
  final Widget child;

  const ThemedRaisedButton({
    Key key,
    @required this.buttonTheme,
    @required this.onPressed,
    this.onHighlightChanged,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.elevation,
    this.focusElevation,
    this.hoverElevation,
    this.highlightElevation,
    this.disabledElevation,
    this.padding,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    this.animationDuration,
    this.child,
  }) : assert(buttonTheme != null);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buttonTheme.themeData,
      child: RaisedButton(
        onPressed: this.onPressed,
        onHighlightChanged: this.onHighlightChanged,
        textTheme: this.textTheme,
        textColor: this.textColor,
        disabledTextColor: this.disabledTextColor,
        color: this.color,
        disabledColor: this.disabledColor,
        focusColor: this.focusColor,
        hoverColor: this.hoverColor,
        highlightColor: this.highlightColor,
        splashColor: this.splashColor,
        colorBrightness: this.colorBrightness,
        elevation: this.elevation ?? this.buttonTheme.elevation.elevation,
        focusElevation: this.focusElevation ?? this.buttonTheme.elevation.focusElevation,
        hoverElevation: this.hoverElevation ?? this.buttonTheme.elevation.hoverElevation,
        highlightElevation: this.highlightElevation ?? this.buttonTheme.elevation.highlightElevation,
        disabledElevation: this.disabledElevation ?? this.buttonTheme.elevation.disabledElevation,
        padding: this.padding,
        shape: this.shape,
        clipBehavior: this.clipBehavior,
        focusNode: this.focusNode,
        autofocus: this.autofocus,
        materialTapTargetSize: this.materialTapTargetSize,
        animationDuration: this.animationDuration,
        child: this.child,
      ),
    );
  }
}
