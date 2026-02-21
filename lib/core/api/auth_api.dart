import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<Response> login(String nickname, String password) {
    return dio.post(
      '/auth/login',
      data: {
        'nickname': nickname,
        'password': password,
      },
    );
  }

  Future<Response> register(String nickname, String email, String password) {
    return dio.post(
      '/auth/registration',
      data: {
        'nickname': nickname,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> logout(String? refreshToken) {
    return dio.delete(
      '/auth/logout',
      data: {'refreshToken': refreshToken},
    );
  }

  Future<Response> refresh(String refreshToken) {
    return dio.post(
      '/auth/refresh?refreshToken=$refreshToken'
    );
  }
}