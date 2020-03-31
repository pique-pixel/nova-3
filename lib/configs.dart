import 'package:rp_mobile/config.dart';

devConfig() => Config(
      appName: 'RussPass [DEV]',
      apiBaseUrl: 'https://api.russpass.iteco.dev',
      apiClientId: 'russpass',
      apiSecretKey: 'secret',
      apiBaseAuthToken: 'cnVzc3Bhc3M6c2VjcmV0',
      apiLogging: true,
      diagnostic: true,
    );
