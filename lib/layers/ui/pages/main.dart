import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rp_mobile/layers/ui/app_icons.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/themes.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_scaffold.dart';
import 'package:rp_mobile/layers/ui/widgets/base/bottom_nav_bar.dart';
import 'package:rp_mobile/layers/ui/widgets/temp_widgets/temp_text_style.dart';
import 'package:rp_mobile/layers/ui/pages/tickets/aeroexpress.dart';
import 'package:rp_mobile/layers/ui/pages/package_details.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'dart:io';

class MainPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => MainPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      theme: AppThemes.materialAppTheme(),
      bottomNavigationBar: BottomNavBar(index: BottomNavPageIndex.favourites),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 8),
            _Header(),
            SizedBox(height: 32),
            _Status(),
            SizedBox(height: 40),
            _Steps(),
            SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 11),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '16 декабря • Солнечно -9 С°',
                  ),
                  Text(
                    'Добро пожаловать \nв Москву!',
                    style: TextStyle(
                      fontFamily: 'PT Russia Text',
                      fontSize: 24,
                      fontWeight: NamedFontWeight.bold,
                      height: 32 / 24,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.pineGreen.withOpacity(0.10),
              ),
              alignment: Alignment.center,
              child: Text(
                'RR',
                style: TextStyle(
                  color: AppColors.pineGreen,
                  fontSize: 14,
                  letterSpacing: -0.1,
                  fontWeight: NamedFontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Status extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Roni Rikkonen',
              style: TempTextStyles.subTitle1,
            ),
            Spacer(),
            Icon(
              AppIcons.check_mark,
              size: 15,
              color: AppColors.pineGreen,
            ),
            SizedBox(width: 5),
            Text(
              'E-visa подтверждена',
              style: TextStyle(
                fontFamily: 'PT Russia Text',
                fontSize: 14,
                fontWeight: NamedFontWeight.medium,
                letterSpacing: -0.1,
                height: 18 / 14,
                color: AppColors.pineGreen,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          '26.12.2019 — 10.01.2020',
          style: TextStyle(
            fontFamily: 'PT Russia Text',
            fontSize: 14,
            fontWeight: NamedFontWeight.medium,
            letterSpacing: -0.1,
            height: 18 / 17,
            color: AppColors.darkGray.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

class _Steps extends StatelessWidget {
  showExpressTicket(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _BottomSheetAeroExpress();
      },
    );
  }

  _launchTaxiUrl() async {
    bool installedTaxi;
    String androidTaxi = "ru.yandex.taxi";
    String iosTaxi = "ru.yandex.taxi://";
    if (Platform.isAndroid) {
      installedTaxi = await AppAvailability.isAppEnabled(androidTaxi);
      if (installedTaxi) {
//        print(await AppAvailability.checkAvailability(packageTaxi));
//        print(await AppAvailability.isAppEnabled(packageTaxi));
        AppAvailability.launchApp(androidTaxi);
      } else {
        OpenAppstore.launch(androidAppId: androidTaxi);
      }
    } else if (Platform.isIOS) {
      //@todo как в огрызке яндекс такси назывется?
//      print(await AppAvailability.checkAvailability("ru.yandex.taxi://"));
      installedTaxi = await AppAvailability.isAppEnabled(iosTaxi);
      if (installedTaxi) {
//        print(await AppAvailability.checkAvailability(packageTaxi));
//        print(await AppAvailability.isAppEnabled(packageTaxi));
        AppAvailability.launchApp(iosTaxi);
      } else {
        OpenAppstore.launch(iOSAppId: iosTaxi);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Step(
          count: 1,
          title: 'Как получить туристический пакет?',
          text: 'Ближайший терминал от Вас: Внуково, терминал А, 1 этаж. На стойке регистрации покажите уникальный код сотруднику.',
          child: _ImageWithQr(),
        ),
        _Step(
          count: 2,
          title: 'Трансфер',
          text: 'Сделайте вашу поездку проще вместе со скоростным поездом или городским такси.',
          child: Column(
            children: <Widget>[
              SizedBox(height: 16),
              _TransferButtons(
                image: 'images/mock_images/aero_express.png',
                onTap: () => showExpressTicket(context),
                title: 'Билет на Аэроэкспресс',
                subtitle: 'Скоростной поезд',
              ),
              SizedBox(height: 16),
              _TransferButtons(
                image: 'images/mock_images/yandex_taxi.png',
                onTap: _launchTaxiUrl,
                title: 'Яндекс Такси',
                subtitle: 'Городское такси',
              )
            ],
          ),
        ),
        _Step(
          count: 3,
          title: 'Жилье',
          text: 'Ваше бронирование в г. Москва подтверждено. Аpart-hotel Garden Embassy ожидает вас 16 декабря.',
          child: _Hotel(),
          isLast: true,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    Key key,
    this.isLast = false,
    this.child,
    @required this.count,
    @required this.title,
    @required this.text,
  }) : super(key: key);

  final Widget child;
  final bool isLast;
  final int count;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryRed,
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.only(left: 3, top: 12, bottom: isLast ? 12 : 4),
            child: Container(
              width: 2,
              color: AppColors.primaryRed,
            ),
          ),
        ),
        if (isLast)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 40, left: 16),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.fromLTRB(16, 16, 23, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Шаг $count',
                      style: TextStyle(
                        fontFamily: 'PT Russia Text',
                        fontSize: 14,
                        fontWeight: NamedFontWeight.medium,
                        height: 18 / 14,
                        letterSpacing: -0.1,
                        color: AppColors.darkGray.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      title,
                      style: TempTextStyles.subTitle1,
                    ),
                    SizedBox(height: 12),
                    Text(
                      text,
                      style: TempTextStyles.text1.copyWith(
                        color: AppColors.darkGray.withOpacity(0.8),
                      ),
                    )
                  ],
                ),
              ),
              if (child != null) child
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageWithQr extends StatelessWidget {
  showQrCode(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _BottomSheetPackage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 8),
        _Button(
          onPressed: () => showQrCode(context),
          text: 'QR-код для получения пакета',
          buttonType: _ButtonType.red,
        ),
        SizedBox(height: 24),
        Image.asset(
          'images/mock_images/moscow_3_days.png',
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(PackagesDetailPage.route('5e55261f826e00001944c576'));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Единый билет для туристического пакета «Москва за 3 дня»',
                  style: TempTextStyles.subTitle1,
                ),
              ),
              Icon(Icons.arrow_forward, color: AppColors.darkGray),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hotel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(height: 16),
        Image.asset(
          'images/mock_images/hotel.png',
        ),
        SizedBox(height: 12),
        Text(
          'Аpart-hotel Garden Embassy',
          style: TempTextStyles.subTitle1,
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Ботанический переулок, 5',
              style: TextStyle(
                color: AppColors.darkGray.withOpacity(0.8),
                fontSize: 16,
                height: 22 / 16,
                letterSpacing: -0.1,
              ),
            ),
            Text(
              '~ 3,5 км ',
              style: TextStyle(
                color: AppColors.darkGray.withOpacity(0.5),
                fontSize: 16,
                height: 22 / 16,
                letterSpacing: -0.1,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _TransferButtons extends StatelessWidget {
  const _TransferButtons({
    Key key,
    this.onTap,
    this.title,
    this.subtitle,
    this.image,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String subtitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            Image.asset(
              image,
              width: 72,
              height: 72,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TempTextStyles.subTitle1,
                ),
                Text(subtitle, style: TempTextStyles.text1)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _QRCode extends StatelessWidget {
  final String code;

  const _QRCode({
    Key key,
    @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(23),
      child: QrImage(
        data: code,
        version: QrVersions.auto,
        size: 165.0,
      ),
    );
  }
}

class _BottomSheetPackage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Color(0xFFC4C4C4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'RUSSPASS',
                style: TextStyle(
                  fontFamily: 'PT Russia Text',
                  fontSize: 12,
                  fontWeight: NamedFontWeight.semiBold,
                  height: 18 / 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Единый билет для туристического пакета «Москва за 3 дня»',
                style: TempTextStyles.subTitle1.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 32),
              _QRCode(code: "R0P3D7MWEW"),
              SizedBox(height: 6),
              Text(
                'Покажите QR-код сотруднику',
                style: TextStyle(
                  fontFamily: 'PT Russia Text',
                  fontSize: 14,
                  height: 20 / 14,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 32),
              _Button(
                text: 'Подробнее о пакете',
                onPressed: () {
                  Navigator.of(context).push(PackagesDetailPage.route('5e55261f826e00001944c576'));
                },
              ),
              SizedBox(height: 34),
            ],
          ),
        )
      ],
    );
  }
}

class _BottomSheetAeroExpress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(
          child: Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(color: Color(0xFFC4C4C4), borderRadius: BorderRadius.circular(2)),
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 24),
          decoration: BoxDecoration(
            color: AppColors.primaryRed,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(8),
              topRight: const Radius.circular(8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'RUSSPASS',
                style: TextStyle(
                  fontFamily: 'PT Russia Text',
                  fontSize: 12,
                  fontWeight: NamedFontWeight.semiBold,
                  height: 18 / 12,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Билет "Aэроэкспресс"\n'
                'скоростной поезд',
                style: TempTextStyles.subTitle1.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 32),
              _QRCode(code: "R0P3D7MWEW"),
              SizedBox(height: 6),
              _Button(
                text: 'Подробнее о билете',
                onPressed: () {
                  Navigator.of(context).push(AeroexpressPage.route());
                },
              ),
              SizedBox(height: 34),
            ],
          ),
        )
      ],
    );
  }
}

enum _ButtonType {
  red,
  gray,
}

class _Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final _ButtonType buttonType;

  const _Button({
    Key key,
    @required this.text,
    this.onPressed,
    this.buttonType = _ButtonType.gray,
  })  : this.backgroundColor = buttonType == _ButtonType.gray ? const Color(0xFFF8F8F8) : AppColors.primaryRed,
        this.textColor = buttonType == _ButtonType.gray ? AppColors.primaryRed : Colors.white,
        super(key: key);

  final Color backgroundColor;
  final Color textColor;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<_Button> {
  bool _isPressed = false;

  buttonStyle(pressed) => TxtStyle()
    ..background.color(widget.backgroundColor)
    ..alignmentContent.center()
    ..textColor(widget.textColor)
    ..borderRadius(all: 8)
    ..height(54)
    ..width(343)
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
