import 'package:flutter/material.dart';

import 'colors.dart';

class AppThemes {
  static ThemeData materialAppTheme() => ThemeData(
        fontFamily: 'Open Sans',
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        primarySwatch: Colors.red,
      );

  static routesAppTheme() => ThemeData(
        fontFamily: 'Open Sans',
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.backgroundGray,
        primarySwatch: Colors.red,
      );

  static pageBrightnessLightTheme() => ThemeData(
        fontFamily: 'Open Sans',
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        primarySwatch: Colors.red,
      );

  static pageBrightnessDarkTheme() => ThemeData(
        fontFamily: 'Open Sans',
        primaryColorBrightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.white,
        primarySwatch: Colors.red,
      );

  static splashScreenTheme() => ThemeData(
        fontFamily: 'Open Sans',
        backgroundColor: AppColors.primaryRed,
        scaffoldBackgroundColor: AppColors.primaryRed,
        primaryColorBrightness: Brightness.dark,
      );

  static ticketModalTheme() => ThemeData(
        fontFamily: 'Open Sans',
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.white,
        primarySwatch: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 100,
        ),
      );

  static bigButtonTheme() => AppButtonTheme(
        themeData: ThemeData(
          accentColor: Colors.white,
          buttonTheme: ButtonThemeData(
            buttonColor: AppColors.primaryRed,
            height: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            splashColor: Colors.white24,
            highlightColor: Colors.white10,
            textTheme: ButtonTextTheme.accent,
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          textTheme: const TextTheme(
            button: const TextStyle(
              fontSize: 17,
            ),
          ),
        ),
        elevation: ButtonThemeElevation(
          elevation: 0,
          highlightElevation: 3,
        ),
      );

  static whiteFlatButton() => ThemeData(
        accentColor: Colors.white,
        buttonTheme: ButtonThemeData(
          height: 32,
          textTheme: ButtonTextTheme.accent,
        ),
        textTheme: const TextTheme(
          button: const TextStyle(
            fontSize: 17,
          ),
        ),
      );

  static flatButton() => ThemeData(
        accentColor: Color(0xFF9B9B9B),
        buttonTheme: ButtonThemeData(
          height: 50,
          textTheme: ButtonTextTheme.accent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        textTheme: const TextTheme(
          button: const TextStyle(
            fontSize: 17,
          ),
        ),
      );
}

class ButtonThemeElevation {
  final double elevation;
  final double focusElevation;
  final double hoverElevation;
  final double highlightElevation;
  final double disabledElevation;

  ButtonThemeElevation({
    this.elevation = 2.0,
    this.focusElevation = 4.0,
    this.hoverElevation = 4.0,
    this.highlightElevation = 8.0,
    this.disabledElevation = 0.0,
  });
}

class AppButtonTheme {
  final ThemeData themeData;
  final ButtonThemeElevation elevation;

  AppButtonTheme({
    @required this.themeData,
    @required this.elevation,
  });
}
