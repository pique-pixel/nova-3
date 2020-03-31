import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';

typedef BottomSheetDecorationBuilder = Widget Function(
    BuildContext context, Widget content);

class ModalBottomSheetRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final bool isScrollControlled;
  final BottomSheetDecorationBuilder decoratorBuilder;
  final Color barrierColor;
  final bool barrierDismissible;
  final double maxHeightFactory;

  ModalBottomSheetRoute({
    @required this.builder,
    @required this.decoratorBuilder,
    this.maxHeightFactory = 9.0 / 16.0,
    this.barrierColor = AppColors.bottomSheetBarrierColor,
    this.barrierDismissible = true,
    this.isScrollControlled = false,
  });

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(
        route: this,
        maxHeightFactory: maxHeightFactory,
        isScrollControlled: isScrollControlled,
      ),
    );

    return bottomSheet;
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 200);
}

class _ModalBottomSheet<T> extends StatefulWidget {
  final bool isScrollControlled;
  final double maxHeightFactory;

  const _ModalBottomSheet({
    Key key,
    @required this.route,
    @required this.isScrollControlled,
    @required this.maxHeightFactory,
  }) : super(key: key);

  final ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          // Disable the initial animation when accessible navigation is on so
          // that the semantics are added to the tree at the correct time.
          final double animationValue = mediaQuery.accessibleNavigation
              ? 1.0
              : widget.route.animation.value;
          return Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            child: ClipRect(
              child: CustomSingleChildLayout(
                delegate: _ModalBottomSheetLayout(
                  animationValue,
                  widget.isScrollControlled,
                  widget.maxHeightFactory,
                ),
                child: BottomSheet(
                  backgroundColor: Colors.transparent,
                  animationController: widget.route._animationController,
                  onClosing: () {
                    if (widget.route.isCurrent) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context) {
                    return widget.route.decoratorBuilder(
                      context,
                      widget.route.builder(context),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  final double progress;
  final bool isScrollControlled;
  final double maxHeightFactor;

  _ModalBottomSheetLayout(
    this.progress,
    this.isScrollControlled,
    this.maxHeightFactor,
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight * maxHeightFactor,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
