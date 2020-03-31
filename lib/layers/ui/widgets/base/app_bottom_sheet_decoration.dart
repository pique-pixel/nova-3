import 'package:flutter/material.dart';

class AppBottomSheetDecoration extends StatelessWidget {
  final Widget child;

  const AppBottomSheetDecoration({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                blurRadius: 56,
                spreadRadius: 18,
                offset: Offset(0, -4),
                color: Color.fromARGB(90, 0, 0, 0),
              )
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
