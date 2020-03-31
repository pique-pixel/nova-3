import 'package:dio/dio.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/model/registerResponse.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionServiceImpl implements SessionService {
  final ApiGateway _apiGateway;
  final Config _config;

  SessionServiceImpl(this._apiGateway, this._config);

  Future<void> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', session.email);
    await prefs.setString('password', session.password);
    await prefs.setString('accessToken', session.accessToken);
    await prefs.setString('refreshToken', session.refreshToken);
    await prefs.setString('tokenType', session.tokenType);
    _apiGateway.updateSession(session);
  }

  Future<Optional<Session>> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final email = prefs.getString('email');
      final password = prefs.getString('password');
      final accessToken = prefs.getString('accessToken');
      final refreshToken = prefs.getString('refreshToken');
      final tokenType = prefs.getString('tokenType');

      if (accessToken == null ||
          refreshToken == null ||
          tokenType == null ||
          email == null ||
          password == null) {
        return Optional.empty();
      }

      final session = Session(
        email: email,
        password: password,
        accessToken: accessToken,
        refreshToken: refreshToken,
        tokenType: tokenType,
      );

      await _apiGateway.updateSession(session);
      return Optional.of(session);
    } on Exception catch (_) {
      return Optional.empty();
    }
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('tokenType');
    await _apiGateway.clearSession();
  }

  Future<bool> shouldDisplayTips() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('shouldDisplayTips') ?? true;
  }

  Future<void> setTipsAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shouldDisplayTips', true);
  }

  Future<LockedResult> isLoginLocked() async {
    // TODO: Implement
    return LockedResult(isLocked: false, until: '15:00');
  }

  @override
  Future<T> refreshSessionOnUnauthorized<T>(Future<T> Function() handler) async {
    try {
      return await handler();
    } on ApiUnauthorizedException catch (_) {
      await refreshSession();
      return await handler();
    }
  }

  @override
  Future<void> refreshSession() async {
    final session = await loadSession();

    if (session.isPresent) {
      final request = TokenRequest(
        clientId: _config.apiClientId,
        scope: 'write',
        secret: _config.apiSecretKey,
        username: session.value.email,
        password: session.value.password,
        grantType: 'password',
      );

      final token = await _apiGateway.token(request);
      final updatedSession = Session(
        email: session.value.email,
        password: session.value.password,
        accessToken: token.access_token,
        refreshToken: token.refresh_token,
        tokenType: token.token_type,
      );

      await saveSession(updatedSession);
    } else {
      await clearSession();
      throw InvalidSessionException();
    }
  }

  @override
  Future<void> saveUser(RegisterResposne register) {
    // TODO: implement saveUser
    print('User needs to be saved in storage');
    return null;
  }
}
