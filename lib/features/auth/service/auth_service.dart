import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:place_see_app/core/api/auth_api.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';

class AuthService {
  final AuthApi authApi;
  final TokenStorage tokenStorage;
  final AuthState authState;

  AuthService(this.authApi, this.tokenStorage, this.authState);

  Future<void> checkAuth() async {
    final accessToken = await tokenStorage.getAccessToken();
    final refreshToken = await tokenStorage.getRefreshToken();

    if (accessToken == null && refreshToken == null) {
      authState.setUnauthenticated();
    } else if (accessToken != null && !JwtDecoder.isExpired(accessToken)) {
      authState.setAuthenticated();
    } else if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
      bool success = await _refreshToken(refreshToken);
      success? authState.setAuthenticated() : authState.setUnauthenticated();
    } else {
      authState.setUnauthenticated();
    }
  }

  Future<void> login(String nickname, String password) async {
    try {
      final response = await authApi.login(nickname, password);
      await _handleAuthResponse(response);
      authState.setAuthenticated();
    } on DioException catch (e) {
      final exceptionResponse = e.response?.data as Map<String, dynamic>;

      if (exceptionResponse.isEmpty || !exceptionResponse.containsKey("message")) {
        throw Exception("Произошла ошибка! Попробуйте снова\n или обратитесь к администратору");
      }

      final exMessage = exceptionResponse["message"];
      throw Exception(exMessage);
    } catch (e) {
      throw Exception("Произошла ошибка! Попробуйте снова\n или обратитесь к администратору");
    }
  }

  Future<void> register(String nickname, String email, String password) async {
    try {
      final response = await authApi.register(nickname, email, password);

      await _handleAuthResponse(response);
      authState.setAfterRegistration();
    } on DioException catch (e) {
      final exceptionResponse = e.response?.data as Map<String, dynamic>;

      if (exceptionResponse.isEmpty || !exceptionResponse.containsKey("message")) {
        throw Exception("Произошла ошибка! Попробуйте снова\n или обратитесь к администратору");
      }

      final exMessage = exceptionResponse["message"];
      throw Exception(exMessage);
    } catch (e) {
      throw Exception("Произошла ошибка! Попробуйте снова\n или обратитесь к администратору");
    }
  }

  Future<void> logout() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    await authApi.logout(refreshToken);
    await tokenStorage.clear();
    authState.setUnauthenticated();
  }

  Future<void> _handleAuthResponse(Response response) async {
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];

    await tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final response = await authApi.refresh(refreshToken);

      _handleAuthResponse(response);
      return true;
    } catch (ex) {
      if (kDebugMode) {
        print(ex.toString());
      }
      await tokenStorage.clear();
      return false;
    }
  }

  void setRegistration() {
    authState.setRegistration();
  }

  void setLogin() {
    authState.setUnauthenticated();
  }
}