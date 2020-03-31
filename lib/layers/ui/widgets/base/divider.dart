import 'package:flutter/cupertino.dart';

class SimpleDivider extends StatelessWidget {
  final double height;
  final Color color;

  const SimpleDivider({
    Key key,
    this.height = 1,
    @required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(color: this.color),
  );
}
