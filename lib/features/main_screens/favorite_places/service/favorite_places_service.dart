import 'package:place_see_app/core/api/favorite_places_api.dart';

import '../../../../core/model/place/place_card.dart';

class FavoritePlacesService {
  final FavoritePlacesApi favoritePlacesApi;

  FavoritePlacesService(this.favoritePlacesApi);

  Future<List<PlaceCard>> getFavoritePlaces() async {
    final rawPlaces = await favoritePlacesApi.getFavPlaces();

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((rawPlace) {
      return PlaceCard.fromJson(rawPlace);
    }).toList();
  }

  Future<void> toggleFavorite(int placeId) async {
    final response = await favoritePlacesApi.toggleFavorite(placeId);

    if (response.statusCode != 200) {
      throw Exception('Не удалось поменять статус избранного у места!');
    }
  }
}