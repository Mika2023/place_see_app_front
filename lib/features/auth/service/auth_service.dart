import 'package:dio/dio.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/core/local_storage/token_storage.dart';

class AuthService {
  final Dio dio;
  final TokenStorage tokenStorage;
  final AuthState authState;

  AuthService(this.dio, this.tokenStorage, this.authState);

  Future<void> login(String nickname, String password) async {
    final response = await dio.post(
        '/auth/login',
        data: {
          'nickname': nickname,
          'password': password,
        },
    );

    await _handleAuthResponse(response);
  }

  Future<void> register(String nickname, String email, String password) async {
    final response = await dio.post(
      '/auth/registration',
      data: {
        'nickname': nickname,
        'email': email,
        'password': password,
      },
    );

    await _handleAuthResponse(response);
  }

  Future<void> logout() async {
    final refreshToken = await tokenStorage.getRefreshToken();
    await dio.delete(
      '/auth/logout',
      data: {'refreshToken': refreshToken},
    );
    await tokenStorage.clear();
    authState.setUnauthenticated();
  }

  Future<void> _handleAuthResponse(Response response) async {
    final accessToken = response.data['accessToken'];
    final refreshToken = response.data['refreshToken'];

    await tokenStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
    authState.setAuthenticated();
  }
}