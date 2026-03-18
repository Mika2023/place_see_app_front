import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<Map<String, dynamic>> editUserProfileInfo(File? image, String? newNickname) async {
    if (newNickname == null && image == null) throw Exception("Переданы пустые аргументы для обновления профиля!");

    final Map<String, dynamic> requestMap = {};

    if (newNickname != null) {
      final requestJson = jsonEncode({
        "nickname": newNickname
      });

      requestMap["request"] = MultipartFile.fromString(
          requestJson,
          contentType: MediaType("application", "json")
      );
    }

    if (image != null) {
      requestMap["image"] = await MultipartFile.fromFile(
          image.path,
          filename: image.path
              .split("/")
              .last
      );
    }

    final formData = FormData.fromMap(requestMap);

    try {
      final response = await dio.post(
          '/user',
          data: formData
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