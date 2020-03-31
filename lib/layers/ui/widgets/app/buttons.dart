import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';

class BigRedRoundedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const BigRedRoundedButton({Key key, @required this.text, this.onPressed}) : super(key: key);

  @override
  _BigRedRoundedButtonState createState() => _BigRedRoundedButtonState();
}

class _BigRedRoundedButtonState extends State<BigRedRoundedButton> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(pressed ? AppColors.middleRed : AppColors.primaryRed)
    ..alignmentContent.center()
    ..textColor(Colors.white)
    ..borderRadius(all: 6)
    ..height(50)
    ..fontSize(17)
    ..margin(horizontal: 50, vertical: 8)
    ..fontWeight(NamedFontWeight.semiBold)
    ..ripple(true, splashColor: Colors.white24, highlightColor: Colors.white10)
    ..boxShadow(blur: pressed ? 17 : 0, offset: [0, pressed ? 4 : 0], color: rgba(247, 70, 78, 0.5))
    ..animate(150, Curves.easeOut);

  GestureClass buttonGestures() => GestureClass()
    ..isTap((isPressed) => setState(() => _isPressed = isPressed))
    ..onTap(widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Txt(
      widget.text,
      style: buttonStyle(_isPressed),
      gesture: buttonGestures(),
    );
  }
}