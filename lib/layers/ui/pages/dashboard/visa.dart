import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';

class Visa extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entities = mockVisas.map((el) => _VisaItem(el)).toList();
    return ListView(
      padding: EdgeInsets.fromLTRB(18, 16, 18, 27),
      children: [
        ...entities,
        SizedBox(height: 58),
        Center(
          child: _Button(
            text: 'Заполнить заявление',
            onPressed: () {},
          ),
        )
      ],
    );
  }
}

class _VisaItem extends StatelessWidget {
  const _VisaItem(this.visaModel);

  final VisaModel visaModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Color(0xFFF5F5F5),
      ),
      margin: EdgeInsets.only(bottom: 18),
      padding: EdgeInsets.fromLTRB(12, 20, 65, 15),
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            visaModel.fullName,
            style: TextStyle(
              color: Color(0xFF262626),
              fontSize: 20,
              fontWeight: NamedFontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            visaModel.sentAt,
            style: TextStyle(
              color: Color(0xFF262626).withOpacity(0.5),
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: _getStatusColor(visaModel.status),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              _getStatusText(visaModel.status),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 20 / 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Color _getStatusColor(VisaStatusType status) {
    switch (status) {
      case VisaStatusType.draft:
        return Color(0xFFB4B4B4);
        break;
      case VisaStatusType.approved:
        return Color(0xFF0C9EA2);
        break;
      case VisaStatusType.rejected:
        return Color(0xFFF7464E);
        break;
      case VisaStatusType.inWork:
        return Color(0xFFFFA858);
        break;
    }
    return null;
  }

  String _getStatusText(VisaStatusType status) {
    switch (status) {
      case VisaStatusType.draft:
        return 'Черновик';
        break;
      case VisaStatusType.approved:
        return 'Одобренно';
        break;
      case VisaStatusType.rejected:
        return 'Отказанно';
        break;
      case VisaStatusType.inWork:
        return 'На рассмотрении';
        break;
    }
    return null;
  }
}

final mockVisas = <VisaModel>[
  VisaModel(
    fullName: 'Анна Петрова',
    sentAt: _dateFormat(DateTime.parse('2019-10-20 20:18:04Z')),
    status: VisaStatusType.inWork,
  ),
  VisaModel(
    fullName: 'Константантин Космодемьянский',
    status: VisaStatusType.draft,
  ),
  VisaModel(
    fullName: 'Алексей Зуев',
    sentAt: _dateFormat(DateTime.parse('2019-10-20 20:18:04Z')),
    status: VisaStatusType.approved,
  ),
  VisaModel(
    fullName: 'Валерий Иванов',
    sentAt: _dateFormat(DateTime.parse('2019-10-20 20:18:04Z')),
    status: VisaStatusType.rejected,
  )
];

String _dateFormat(DateTime dateTime) {
  return DateFormat('Отправленно: EEE, d MMM HH:mm', 'ru').format(dateTime);
}

class VisaModel {
  final String fullName;
  final VisaStatusType status;
  final String sentAt;

  VisaModel({
    @required this.fullName,
    @required this.status,
    this.sentAt = '',
  });
}

enum VisaStatusType {
  draft,
  approved,
  rejected,
  inWork,
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
    ..width(290)
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
