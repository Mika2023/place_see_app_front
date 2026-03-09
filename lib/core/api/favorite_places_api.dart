import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class FavoritePlacesApi {
  final Dio dio;

  FavoritePlacesApi(this.dio);

  Future<Response> toggleFavorite(int placeId) {
    return dio.post('/favorite-places/$placeId');
  }

  Future<List<Map<String, dynamic>>> getFavPlaces() async {
    try {
      final response = await dio.get(
        '/favorite-places',
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
}