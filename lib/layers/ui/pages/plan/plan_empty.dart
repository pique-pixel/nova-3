import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';

class PlanEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          height: 188,
          decoration: BoxDecoration(
            color: AppColors.lightGray,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4.0),
              topLeft: Radius.circular(4.0),
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image(
                image: AssetImage("images/empty_plan.png"),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundGray,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Москва",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
              Text(
                "Список поездок пуст",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: NamedFontWeight.regular,
                  color: AppColors.mediumGray,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
