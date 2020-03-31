import 'package:flutter/widgets.dart';

class LongPressToChangeStateToNext extends StatefulWidget {
  final List<Widget> listWidgetStates;

  const LongPressToChangeStateToNext({Key key, @required this.listWidgetStates}) : super(key: key);

  @override
  _LongPressToChangeStateToNextState createState() => _LongPressToChangeStateToNextState();
}

class _LongPressToChangeStateToNextState extends State<LongPressToChangeStateToNext> {
  int indexState = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          indexState++;
          if (indexState == widget.listWidgetStates.length) {
            indexState = 0;
          }
        });
      },
      child: widget.listWidgetStates.length > 0
          ? widget.listWidgetStates[indexState]
          : SizedBox.shrink(),
    );
  }
}
