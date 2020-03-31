import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/app_icons.dart';

class TempAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 16, 14, 12),
      child: _BackButton(),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.maybePop(context),
      child: Container(
        height: 32,
        width: 130,
        child: Icon(
          AppIcons.rounded_arrow_left,
          size: 15,
          color: Color(0xFF262626),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.23),
      ),
    );
  }
}
