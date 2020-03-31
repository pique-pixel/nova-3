import 'package:flutter/widgets.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/configs.dart';
import 'package:rp_mobile/dependencies.dart';
import 'package:rp_mobile/layers/ui/pages/splash.dart';
import 'package:rp_mobile/app.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';


void main() async {

   
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  final config = devConfig();
  final configuredApp = AppConfig(
    config: config,
    child: RussPassApp(home: SplashScreenProvider()),
  );

  await setUp();
  setupDependencies(config);
  runApp(configuredApp);
}
