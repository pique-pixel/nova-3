import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/pages/dashboard/qr_code_modal.dart';
import 'package:rp_mobile/layers/ui/widgets/base/clip_shadow_path.dart';
import 'dart:math' as math;

class QrCodeModalRoute extends PopupRoute {
  QrCodeModalRoute({RouteSettings settings}) : super(settings: settings);

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
          child: QrCodeModal(),
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
