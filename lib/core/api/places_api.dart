import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class PlacesApi {
  final Dio dio;

  PlacesApi(this.dio);

  Future<List<Map<String, dynamic>>> getPlacesByCatId(int catId) async {
    try {
      final response = await dio.post(
        '/places/filters',
        data: {
          'categoryIds': [catId],
        }
      );

      if (response.statusCode == 200) {
        final data = response.data["content"] as List;
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

  Future<List<Map<String, dynamic>>> searchPlaces(String name) async {
    try {
      final response = await dio.post(
          '/places/search',
          data: {
            'name': name,
          }
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