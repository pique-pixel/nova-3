import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:rp_mobile/layers/ui/colors.dart';

class LoadingIndicator extends StatefulWidget {
  final double radius;
  final Color activeColor;
  final Color backgroundColor;
  final double tickWidth;
  final double lengthFactor;

  const LoadingIndicator({
    Key key,
    this.radius = 26,
    this.activeColor = AppColors.loadingIndicatorActive,
    this.backgroundColor = AppColors.loadingIndicatorBackground,
    this.tickWidth = 4.4,
    this.lengthFactor = 1.6,
  }) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
  }

  _prepareAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animationController.repeat();
  }

  @override
  void didUpdateWidget(LoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _LoadingIndicatorPainter(
          position: _animationController,
          radius: widget.radius,
          width: widget.tickWidth,
          lengthFactor: widget.lengthFactor,
          backgroundColor: widget.backgroundColor,
          activeColor: widget.activeColor,
        ),
      ),
    );
  }
}

class _LoadingIndicatorPainter extends CustomPainter {
  static const double twoPI = math.pi * 2.0;
  static const int tickCount = 12;
  static const int halfTickCount = tickCount ~/ 2;
  
  final Color activeColor;
  final Color backgroundColor;
  final double width;
  final double lengthFactor;

  _LoadingIndicatorPainter({
    this.position,
    double radius,
    @required this.activeColor,
    @required this.backgroundColor,
    @required this.width,
    @required this.lengthFactor,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          width / 2.0,
          -radius / lengthFactor,
          -width / 2.0,
          10.0,
          10.0,
        ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (tickCount * position.value).floor();

    for (int i = 0; i < tickCount; ++i) {
      final double t =
          (((i + activeTick) % tickCount) / (tickCount - 1)).clamp(0.0, 1.0);
      paint.color = Color.lerp(activeColor, backgroundColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-twoPI / tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LoadingIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
