import 'package:place_see_app/core/api/favorite_places_api.dart';
import 'package:place_see_app/core/api/places_api.dart';
import 'package:place_see_app/core/model/place/place_card.dart';
import 'package:place_see_app/core/model/place/place_full_info.dart';

class PlaceService {
  final FavoritePlacesApi favoritePlacesApi;
  final PlacesApi placesApi;

  PlaceService(this.favoritePlacesApi, this.placesApi);

  Future<void> toggleFavorite(int placeId) async {
    final response = await favoritePlacesApi.toggleFavorite(placeId);

    if (response.statusCode != 200) {
      throw Exception('Не удалось поменять статус избранного у места!');
    }
  }

  Future<PlaceFullInfo> loadPlace(int placeId) async {
    final rawPlace = await placesApi.getPlaceById(placeId);

    return PlaceFullInfo.fromJson(rawPlace);
  }

  Future<List<PlaceCard>> loadPlacesNearby(int placeId) async {
    final rawPlaces = await placesApi.getPlacesNearbyByPlaceId(placeId);

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((place) => PlaceCard.fromJson(place)).toList();
  }
}