import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class UserApi {
  final Dio dio;

  UserApi(this.dio);

  Future<Map<String, dynamic>> getUserProfileInfo() async {
    try {
      final response = await dio.get(
          '/user/profile-info'
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return {};
    }
  }
}