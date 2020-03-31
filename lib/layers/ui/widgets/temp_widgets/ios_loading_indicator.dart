import 'package:flutter/cupertino.dart';

class IosLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoTheme(
        data: CupertinoThemeData(brightness: Brightness.dark),
        child: CupertinoActivityIndicator(animating: true),
      ),
    );
  }
}
