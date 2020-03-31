import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/app_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';

class AboutPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => AboutPage());
  Widget _rowButton(String text, String navigateTo) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      trailing: Image.asset(
        'images/expand_less.png',
        height: 25,
      ),
      title: Text(
        text,
        style: TempTextStyles.text1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TempAppBar(),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Image.asset(
                    'images/appIcon.png',
                    height: 56,
                    width: 56,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Планирование путешествий',
                      style: TempTextStyles.text1,
                    ),
                    SizedBox(height: 4,),
                    Text(
                      'Версия: 1.0 от 1 марта 2020',
                      style: GolosTextStyles.mainTextSize16(
                        golosTextColors: GolosTextColors.grayDark,
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'RUSSPASS — это больше, чем просто удобная экосистема для планирования и организации даже самых сложных путешествий по России.',
                style: GolosTextStyles.mainTextSize16(
                  golosTextColors: Colors.black
                )
              ),
            ),
            _rowButton('Договор оферты', ''),
            Divider(
              indent: 16,
              endIndent: 16,
              height: 0,
            ),
            _rowButton('Политика конфиденциальности', ''),
            Divider(
              indent: 16,
              endIndent: 16,
              height: 0,
            ),
            _rowButton('Оценить приложение', ''),
            Divider(
              height: 0,
              indent: 16,
              endIndent: 16
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                '© 2020 Проект Правительства',
                style: GolosTextStyles.mainTextSize16(
                  golosTextColors: GolosTextColors.grayDark,
                ).copyWith(fontSize: 12),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                ' sМосквы',
                style: GolosTextStyles.mainTextSize16(
                  golosTextColors: GolosTextColors.grayDark,
                ).copyWith(fontSize: 12),
              ),
            ),
            SizedBox(height: 35,)
          ],
        ),
      ),
    );
  }
}

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button({Key key, @required this.text, this.onPressed})
      : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(pressed ? AppColors.middleRed : Colors.white)
    ..alignmentContent.centerLeft()
    ..textColor(Color(0xFF262626))
    ..borderRadius(all: 2)
    ..boxShadow(blur: 1, offset: [0, 1], color: Colors.black.withOpacity(0.05))
    ..width(double.infinity)
    ..padding(left: 24)
    ..height(62)
    ..fontSize(17)
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
