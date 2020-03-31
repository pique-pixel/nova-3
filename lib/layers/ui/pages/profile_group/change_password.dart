import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/app_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class ChagePasswordPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => ChagePasswordPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TempAppBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Смена пароля',
                  style: TempTextStyles.pageTitle1,
                ),
                SizedBox(
                  height: 25,
                ),
                textForm('текущий пароль'),
                SizedBox(
                  height: 15,
                ),
                textForm('новый пароль'),
              ],
            ),
          ),
          Spacer(),
          Center(
            child: _Button(
              text: 'Сохранить',
              onPressed: () {},
            ),
          ),
          SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  Widget textForm(hint) {
    return TextFormField(
      obscureText: true,
      style: TextStyle(height: 26 / 17),
      decoration: InputDecoration(
        focusColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 17,
        ),
      ),
      keyboardType: TextInputType.text,
    );
  }
}

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button({Key key, @required this.text, this.onPressed}) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(pressed ? AppColors.middleRed : AppColors.primaryRed)
    ..alignmentContent.center()
    ..textColor(Colors.white)
    ..borderRadius(all: 6)
    ..height(60)
    ..width(174)
    ..fontSize(17)
    ..fontWeight(NamedFontWeight.semiBold)
    ..ripple(true, splashColor: Colors.white24, highlightColor: Colors.white10)
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
