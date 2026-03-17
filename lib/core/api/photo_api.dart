import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class PhotoApi {
  final Dio dio;

  PhotoApi(this.dio);

  Future<List<Map<String, dynamic>>> getPhotosByUser() async {
    try {
      final response = await dio.get(
          '/photos'
      );

      if (response.statusCode == 200) {
        final data = response.data['content'] as List;
        return data.map((el) => el as Map<String, dynamic>).toList();
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<Map<String, dynamic>> createPhoto(int placeId, File file) async {
    final requestJson = jsonEncode({
      "placeId": placeId,
      "isMain": false,
    });

    final formData = FormData.fromMap({
      "request": MultipartFile.fromString(
          requestJson,
          contentType: MediaType("application", "json")
      ),
      "image": await MultipartFile.fromFile(
        file.path,
        filename: file.path.split("/").last
      ),
    });

    try {
      final response = await dio.post(
          "/photos",
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