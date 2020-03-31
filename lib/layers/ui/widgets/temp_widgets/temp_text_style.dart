import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rp_mobile/layers/ui/colors.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';

class TempTextStyles {
  static TextStyle subTitle1 = TextStyle(
    fontFamily: 'PT Russia Text',
    fontSize: 17,
    fontWeight: NamedFontWeight.semiBold,
    letterSpacing: -0.2,
    height: 24 / 17,
  );

  static TextStyle text1 = TextStyle(
    fontFamily: 'PT Russia Text',
    fontSize: 16,
    fontWeight: NamedFontWeight.medium,
    height: 22 / 16,
    letterSpacing: -0.1,
  );

  static TextStyle pageTitle1 = TextStyle(
    fontWeight: NamedFontWeight.bold,
    fontSize: 24,
    height: 32 / 24,
    color: Colors.black,
  );
}



class GolosTextStyles {
  static final String fontFamily = 'Golos';


  static TextStyle baseStyle = TextStyle(
    fontFamily: fontFamily,
    letterSpacing: -0.1,
  );

  static TextStyle h1size30({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: golosTextColors,
    );
  }

  static TextStyle h2size20({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: golosTextColors,
    );
  }

  static TextStyle h3size16({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: golosTextColors,
    );
  }

  static TextStyle mainTextSize16({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: golosTextColors,
    );
  }

  static TextStyle additionalSize14({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: golosTextColors,
    );
  }

  static TextStyle buttonStyleSize14({@required Color golosTextColors}) {
    return baseStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: golosTextColors,
    );
  }
}

class GolosTextColors {
  static const Color grayDarkVery = AppColors.darkGray;
  static const Color white = AppColors.white;
  static const Color red = AppColors.primaryRed;
  static const Color redMiddle = AppColors.middleRed;
  static const Color grayDark = AppColors.greyDark;
  static const Color grayBright = AppColors.greyBright;
}
