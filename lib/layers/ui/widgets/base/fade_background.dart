import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FadeBackgroundImage extends StatefulWidget {
  final ImageProvider image;
  final Color backgroundColor;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final Widget child;

  const FadeBackgroundImage(
    this.image, {
    Key key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.child,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);

  @override
  _FadeBackgroundImageState createState() => _FadeBackgroundImageState();
}

class _FadeBackgroundImageState extends State<FadeBackgroundImage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
    _animationController.animateTo(1.0, curve: Curves.ease);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _prepareAnimations() {
    _animationController = AnimationController(
      vsync: this,
      value: 0.0,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: Container(color: widget.backgroundColor)),
        FadeTransition(
          opacity: _animationController,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.image,
                fit: widget.fit,
                alignment: widget.alignment,
              ),
            ),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
