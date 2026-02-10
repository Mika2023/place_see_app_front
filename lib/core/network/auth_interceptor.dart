import 'dart:async';
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:dio/dio.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage tokenStorage;
  final AuthState authState;

  bool _isRefreshing = false;
  final List<Completer<void>> _refreshQueue = [];

  AuthInterceptor({required this.dio, required this.tokenStorage, required this.authState,});

  ///Подставляет в каждый запрос в хэдеры токен доступа
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    bool isPublicEndpoint = options.path.contains('/auth');
    final accessToken = await tokenStorage.getAccessToken();

    if (!isPublicEndpoint && accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isUnauthorizedEx = err.response?.statusCode == 401;
    final isAuthRequest = err.requestOptions.path.contains('/auth');

    if (!isUnauthorizedEx || isAuthRequest) {
      handler.next(err);
      return;
    }

    try {
      await _handleRefreshToken();
      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      await tokenStorage.clear();
      authState.setUnauthenticated();
      handler.next(err);
    }
  }

  ///обновить токен
  Future<void> _handleRefreshToken() async {
    if (_isRefreshing) {
      final completer = Completer<void>();
      _refreshQueue.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('Токен обновления доступа отсутствует');
      }

      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': null})
      );

      if (response.statusCode == 403 || response.statusCode == 401) {
        throw Exception('Токен обновления доступа истек или отсутсвует');
      }

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await tokenStorage.saveTokens(accessToken: newAccessToken, refreshToken: newRefreshToken);

      for (final completer in _refreshQueue) {
        completer.complete();
      }
      _refreshQueue.clear();
    } catch (e) {
      for (final completer in _refreshQueue) {
        completer.completeError(e);
      }
      _refreshQueue.clear();
      rethrow;
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await tokenStorage.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {
        ... requestOptions.headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}