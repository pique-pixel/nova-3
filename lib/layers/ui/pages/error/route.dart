import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/pages/error/page.dart';

class ErrorPageRoute extends PopupRoute {
  ErrorPageRoute({
    RouteSettings settings,
  }) : super(settings: settings);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

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
          child: ErrorPage(),
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
      alignment: Alignment.bottomCenter,
      child: SizeTransition(
        axisAlignment: 0.0,
        sizeFactor: animation,
        child: child,
      ),
    );
  }
}
