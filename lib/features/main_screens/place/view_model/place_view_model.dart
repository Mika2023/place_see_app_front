import 'package:flutter/foundation.dart';
import 'package:place_see_app/core/model/filters/transport_type_enum.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/core/model/place/place_card.dart';
import 'package:place_see_app/core/model/place/place_full_info.dart';
import 'package:place_see_app/features/main_screens/place/service/place_service.dart';

import '../../favorite_places/view_model/favorite_places_view_model.dart';

class PlaceViewModel extends ChangeNotifier{
  List<PhotoFullInfo> _mainPhotos = [];
  PlaceFullInfo? placeFullInfo;
  List<String> tags = [];
  List<PhotoFullInfo> _userPhotos = [];
  List<PlaceCard>? placesNearby;
  PlaceService? placeService;
  FavoritePlacesViewModel? _favoritePlacesViewModel;
  String? error;
  bool isLoading = false;
  bool isError = false;

  List<PhotoFullInfo> get mainPhotos => _getMainPhotos();
  List<PhotoFullInfo> get userPhotos => _getUserPhotos();

  void update(PlaceService service, FavoritePlacesViewModel favPlacesVM) {
    placeService = service;
    _favoritePlacesViewModel = favPlacesVM;
    notifyListeners();
  }

  Future<void> loadPlace(int id) async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      placeFullInfo = (await placeService?.loadPlace(id))!;
      _getMainPhotos();
      _getUserPhotos();
      _getTags();
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<PhotoFullInfo> _getMainPhotos() {
    _mainPhotos = placeFullInfo!.photos.where((photo) => photo.isMain).toList();
    return _mainPhotos;
  }

  List<PhotoFullInfo> _getUserPhotos() {
    _userPhotos = placeFullInfo!.photos.where((photo) => !photo.isMain).toList();
    return _userPhotos;
  }
  
  void _getTags() {
    tags = placeFullInfo!.tags?.map((tag) => tag.name).toList() ?? [];

    tags.addAll(placeFullInfo!.categories.map((cat) => cat.name));
    notifyListeners();
  }

  Future<void> loadPlacesNearby(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      placesNearby = (await placeService?.loadPlacesNearby(id))!;
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? getMetroStations() {
    if (placeFullInfo == null) return null;
    final metroStations = placeFullInfo!.locationDescription[TransportTypeEnum.metro] ?? [];

    if (metroStations.isEmpty) return null;
    return metroStations.join(', ');
  }

  Future<void> toggleFavorite(int index) async {
    if (index == -1 || placesNearby == null) return;
    final placeId = placesNearby![index].id;

    try {
      placesNearby![index] = placesNearby![index].copyWith(
        isFavorite: !(placesNearby![index].isFavorite ?? false),
      );
      await placeService?.toggleFavorite(placeId);

      final place = placesNearby![index];
      final isFavNew = place.isFavorite ?? false;
      final hasFavInList = _favoritePlacesViewModel?.hasFavoriteInList(placeId) ?? false;
      if (isFavNew) {
        if (!hasFavInList) _favoritePlacesViewModel?.addFavorite(place);
      } else {
        if (hasFavInList) _favoritePlacesViewModel?.removeFavoriteFromList(placeId);
      }
    } catch (e) {
      error = e.toString();

      if (kDebugMode) print(error);
    } finally {
      notifyListeners();
    }
  }
}