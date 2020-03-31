import 'package:dio/dio.dart';
import 'package:rp_mobile/config.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';
import 'package:rp_mobile/layers/drivers/api/model/errorResponse.dart';
import 'package:rp_mobile/layers/drivers/api/model/registerResponse.dart';
import 'package:rp_mobile/layers/drivers/api/models.dart';
import 'package:rp_mobile/layers/drivers/api/session.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';

class AuthServiceImpl implements AuthService {
  final ApiGateway _apiGateway;
  final SessionService _sessionService;
  final Config _config;

  AuthServiceImpl(this._apiGateway, this._sessionService, this._config);

  @override
  Future<void> login(String email, String password) async {
    final request = TokenRequest(
      clientId: _config.apiClientId,
      scope: 'write',
      secret: _config.apiSecretKey,
      username: email,
      password: password,
      grantType: 'password',
    );

    try {
      final token = await _apiGateway.token(request);
      final session = Session(
        email: email,
        password: password,
        accessToken: token.access_token,
        refreshToken: token.refresh_token,
        tokenType: token.token_type,
      );
      await _sessionService.saveSession(session);
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        throw InvalidLoginOrPasswordException();
      } else {
        throw e;
      }
    }
  }

  @override
  Future<void> register(String email, String password, String matchingPassword, String firstName, String lastName)async{
   
     final request = RegisterRequest(
       email: email,
       password: password,
       matchingPassword: matchingPassword,
       firstName: "   ",
       lastName: "    "
     );

    try {
      final user = await _apiGateway.createSession(request);
      
      await _sessionService.saveUser(user);
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
         var error = ErrorResponse.fromJson(e.response.data);
        throw RegisterFailError(error: error);
      } else {
        throw e;
      }
    }
  }
  
  
}
