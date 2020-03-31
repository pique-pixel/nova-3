import 'package:flutter/widgets.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/configs.dart';
import 'package:rp_mobile/dependencies.dart';
import 'package:rp_mobile/layers/ui/pages/splash.dart';
import 'package:rp_mobile/app.dart';

void main() async {
  final config = devConfig().copyWith(appName: 'RussPass [LOCAL]');
  final configuredApp = AppConfig(
    config: config,
    child: RussPassApp(home: SplashScreenProvider()),
  );

  await setUp();
  setupDependencies(config);
  runApp(configuredApp);
}
