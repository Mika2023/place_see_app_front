import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class TagApi {
  final Dio dio;

  TagApi(this.dio);

  Future<List<Map<String, dynamic>>> getAllTags() async {
    try {
      final response = await dio.get(
        '/tags',
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
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
}