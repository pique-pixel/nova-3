import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/layers/drivers/api/model/registerResponse.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';

class LockedResult {
  final bool isLocked;
  final String until;

  LockedResult({this.isLocked, this.until}) : assert(isLocked != null);
}

abstract class SessionService {
  Future<void> saveSession(Session session);
  
  Future<void> saveUser(RegisterResposne register);

  Future<Optional<Session>> loadSession();

  Future<void> refreshSession();

  Future<void> clearSession();

  Future<bool> shouldDisplayTips();

  Future<void> setTipsAsRead();

  Future<LockedResult> isLoginLocked();

  Future<T> refreshSessionOnUnauthorized<T>(Future<T> Function() handler);
}
