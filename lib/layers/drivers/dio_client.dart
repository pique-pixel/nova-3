import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/exceptions.dart';
import 'package:rp_mobile/layers/drivers/api/gateway.dart';

import 'api/session.dart';

class DioClient {
  final _dio = Dio();
  final String baseEndpoint;
  final bool logging;

  DioClient({
    this.baseEndpoint,
    this.logging = false,
  })  : assert(baseEndpoint != null),
        assert(logging != null) {
    if (logging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          responseHeader: true,
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Map<String, dynamic> _createAuthHeaders(Session session) {
    if (!session.hasExpired()) {
      return <String, dynamic>{
        'Authorization': 'Bearer ${session.accessToken}'
      };
    } else {
      return <String, dynamic>{};
    }
  }

  Options _defaultOptions(Session session) {
    return Options(headers: _createAuthHeaders(session));
  }

  Options _createOptions(Options options, Optional<Session> session) {
    assert(session != null);

    if (options != null) {
      return options;
    } else if (session.isPresent) {
      return _defaultOptions(session.value);
    } else {
      return Options();
    }
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.get(
        '$baseEndpoint$endpoint',
        options: _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  //TODO dubl !
//  Future<Response<T>> delete<T>(String endpoint, {
//    Options options,
//    Optional<Session> session = const Optional.empty(),
//  }) async {
//    try {
//      return await _dio.delete(
//        '$baseEndpoint$endpoint',
//        options: _createOptions(options, session),
//      );
//    } on DioError catch (e) {
//      throw _handleError(e);
//    }
//  }

  Future<Response<T>> post<T>(
    String endpoint, {
    data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.post(
        '$baseEndpoint$endpoint',
        data: data,
        options: _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.patch(
        '$baseEndpoint$endpoint',
        data: data,
        options: _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.put(
        '$baseEndpoint$endpoint',
        data: data,
        options: _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String endpoint, {
    data,
    Options options,
    Optional<Session> session = const Optional.empty(),
  }) async {
    try {
      return await _dio.delete(
        '$baseEndpoint$endpoint',
        data: data,
        options: _createOptions(options, session),
      );
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> getJsonBody<T>(Response<T> response) {
    try {
      return response.data as Map<String, dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  List<dynamic> getJsonBodyList<T>(Response<T> response) {
    try {
      return response.data as List<dynamic>;
    } on Exception catch (e, stackTrace) {
      debugPrint(stackTrace.toString());
      throw SchemeConsistencyException('Bad body format');
    }
  }

  Exception _handleError(DioError e) {
    if (e.response.statusCode == 401) {
      return ApiUnauthorizedException();
    } else {
      // TODO: get rid of DioError and use ApiException
      return e;
    }
  }
}
