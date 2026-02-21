import 'package:dio/dio.dart';

class FavoritePlacesApi {
  final Dio dio;

  FavoritePlacesApi(this.dio);

  Future<Response> toggleFavorite(int placeId) {
    return dio.post('/favorite-places/$placeId');
  }
}