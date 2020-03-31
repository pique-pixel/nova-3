import 'package:division/division.dart';
import 'package:flutter/material.dart';
//import 'package:rp_mobile/layers/ui/pages/dashboard/qr_code_modal.dart';
import 'package:rp_mobile/layers/ui/widgets/base/clip_shadow_path.dart';
import 'dart:math' as math;

class ModalAero extends PopupRoute {
  ModalAero({RouteSettings settings}) : super(settings: settings);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => rgba(38, 38, 38, 0.6);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: _Container(
          animation: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: PdfModal(),
        ),
      ),
    );
  }
}

class _Container extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _Container({
    Key key,
    @required this.animation,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        child: ClipShadowPath(
          shadow: Shadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, 4),
          ),
          clipper: _Clipper(),
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: SizeTransition(
              axisAlignment: 0.0,
              sizeFactor: animation,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return _getClipPath(size);
  }

  @override
  bool shouldReclip(_Clipper oldClipper) => false;
}

Path _getClipPath(Size size) {
  final path = Path();
  final radius = 14.0;

  path
    ..addRRect(
      RRect.fromLTRBR(0.0, 0.0, size.width, size.height, Radius.circular(6)),
    )
    ..addArc(
      Rect.fromCircle(
        center: Offset(size.width, size.height / 2),
        radius: radius,
      ),
      math.pi / 2,
      math.pi,
    )
    ..addArc(
      Rect.fromCircle(
        center: Offset(0, size.height / 2),
        radius: radius,
      ),
      -math.pi / 2,
      math.pi,
    )
    ..fillType = PathFillType.evenOdd;
  path.close();
  return path;
}

//------
class PdfModal extends StatelessWidget {
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
              'Откройте QR-код и отсканируйте его считывателем турникета '
                  'АЭРОЭКСПРЕСС',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 27),
//          ConstrainedBox(
//            constraints: BoxConstraints(maxWidth: 234),
//            child: Text(
//              'Действует 2 дня 16 часов',
//              textAlign: TextAlign.center,
//              style: TextStyle(fontSize: 14),
//            ),
//          ),
//          SizedBox(height: 30),
          _DashedSplitLine(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Image.asset('images/pdf_icon.png')//_QRCode(),
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
                'АЭРОЭКСПРЕСС',
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

