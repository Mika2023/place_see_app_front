import 'package:flutter/foundation.dart';
import 'package:place_see_app/features/main_screens/favorite_places/service/favorite_places_service.dart';

import '../../../../core/model/place/place_card.dart';

class FavoritePlacesViewModel extends ChangeNotifier {
  FavoritePlacesService? favoritePlacesService;
  bool _isLoading = false;
  bool _isError = false;
  List<PlaceCard> _places = [];

  bool get isLoading => _isLoading;
  List<PlaceCard> get places => _places;
  bool get isError => _isError;

  void update(FavoritePlacesService service) {
    favoritePlacesService = service;
    notifyListeners();
  }

  Future<void> loadFavPlaces() async {
    try {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      _places = (await favoritePlacesService?.getFavoritePlaces())!;
    } catch(e) {
      if (kDebugMode) print(e);
      _isError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFavorite(int index) async {
    if (index == -1) return;
    final placeId = _places[index].id;

    try {
      await favoritePlacesService?.toggleFavorite(placeId);
      _places.removeAt(index);
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      notifyListeners();
    }
  }

  void removeFavoriteFromList(int placeId) {
    _places.removeWhere((p) => p.id == placeId);
    notifyListeners();
  }

  void addFavorite(PlaceCard place) {
    _places.add(place);
    notifyListeners();
  }

  bool hasFavoriteInList(int placeId) {
    return _places.any((p) => p.id == placeId);
  }
}