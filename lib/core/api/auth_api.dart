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
      '/auth/logout?refreshToken=$refreshToken',
    );
  }

  Future<Response> refresh(String refreshToken) {
    return dio.post(
      '/auth/refresh?refreshToken=$refreshToken'
    );
  }

  Future<Map<String, dynamic>> sendEmailCodeToChangePassword(String toEmail) async {
    final response = await dio.get(
        '/auth/send-code-for-edit-password?toEmail=$toEmail'
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception("Ответ от апи пришел пустой!");
    }
  }

  Future<Response> editPassword(String newPassword, int userId) {
    return dio.post(
      '/auth/edit-password',
      data: {
        'userId': userId,
        'newPassword': newPassword,
      },
    );
  }
}