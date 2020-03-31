import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.body1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _Header(),
          SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 234),
            child: Text(
              'Покажите QR-код на кассе сотруднику музея',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 27),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 234),
            child: Text(
              'Действует 2 дня 16 часов',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(height: 30),
          _DashedSplitLine(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: _QRCode(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFED1B25),
      child: Stack(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 47),
              child: Text(
                'НАЗВАНИЕ ПАКЕТА',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              highlightColor: Colors.white24,
              icon: const Icon(Icons.close, size: 32, color: Colors.white),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedSplitLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SizedBox(
        width: double.infinity,
        child: CustomPaint(painter: _LineDashedPainter()),
      ),
    );
  }
}

class _LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color(0xFFD8D8D8);
    final strokeWidth = 2.0;
    var max = size.width;
    final dashWidth = 5.0;
    final dashSpace = 3.0;
    double startX = 0;

    while (max >= 0) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          startX,
          0,
          startX + dashWidth,
          strokeWidth,
          Radius.circular(dashWidth),
        ),
        paint,
      );
      final space = (dashSpace + dashWidth);
      startX += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _QRCode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: "1234567890123456789012345678901234567890",
      version: QrVersions.auto,
      size: 200.0,
    );
  }
}
