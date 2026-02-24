import 'package:place_see_app/core/api/favorite_places_api.dart';
import 'package:place_see_app/core/api/places_api.dart';
import 'package:place_see_app/core/model/filters/places_filters_state.dart';
import 'package:place_see_app/core/model/place/place_card.dart';

class PlacesService {
  final PlacesApi placesApi;
  final FavoritePlacesApi favoritePlacesApi;

  PlacesService(this.placesApi, this.favoritePlacesApi);

  Future<List<PlaceCard>> searchPlaces(String name) async {
    final rawPlaces = await placesApi.searchPlaces(name);

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((rawPlace) {
      return PlaceCard.fromJson(rawPlace);
    }).toList();
  }

  Future<List<PlaceCard>> loadPlaces(int catId) async {
    final rawPlaces = await placesApi.getPlacesByCatId(catId);

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((rawPlace) {
      return PlaceCard.fromJson(rawPlace);
    }).toList();
  }

  Future<List<PlaceCard>> loadPlacesByFilters(PlacesFiltersState filtersState) async {
    final rawPlaces = await placesApi.getPlacesByFilters(filtersState.toDto());

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