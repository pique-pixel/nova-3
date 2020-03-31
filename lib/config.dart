import 'package:flutter/widgets.dart';

class Config {
  final String appName;
  final String apiBaseUrl;
  final String apiSecretKey;
  final String apiClientId;
  final String apiBaseAuthToken;
  final bool apiLogging;
  final bool diagnostic;

  Config({
    @required this.appName,
    @required this.apiBaseUrl,
    @required this.apiSecretKey,
    @required this.apiClientId,
    @required this.apiBaseAuthToken,
    this.apiLogging = false,
    this.diagnostic = false,
  })  : assert(appName != null),
        assert(apiBaseUrl != null),
        assert(apiSecretKey != null),
        assert(apiClientId != null),
        assert(apiBaseAuthToken != null);

  Config copyWith({
    appName,
    apiBaseUrl,
    apiSecretKey,
    apiClientId,
    apiBaseAuthToken,
    apiLogging,
    diagnostic,
  }) {
    return Config(
      appName: appName ?? this.appName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      apiSecretKey: apiSecretKey ?? this.apiSecretKey,
      apiClientId: apiClientId ?? this.apiClientId,
      apiBaseAuthToken: apiBaseAuthToken ?? this.apiBaseAuthToken,
      apiLogging: apiLogging ?? this.apiLogging,
      diagnostic: diagnostic ?? this.diagnostic,
    );
  }
}

class AppConfig extends InheritedWidget {
  final Config config;

  AppConfig({
    @required this.config,
    @required Widget child,
  })  : assert(config != null),
        super(child: child);

  static AppConfig of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppConfig);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
