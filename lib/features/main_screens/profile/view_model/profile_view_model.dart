import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_see_app/core/config/app_config.dart';
import 'package:place_see_app/core/mapper/photos/photo_profile_info_mapper.dart';
import 'package:place_see_app/core/model/photos/photo_full_info.dart';
import 'package:place_see_app/core/model/photos/photo_profile_info.dart';
import 'package:place_see_app/core/model/routes/point.dart';
import 'package:place_see_app/core/model/routes/route_model.dart';
import 'package:place_see_app/core/model/user/user_profile_info.dart';
import 'package:place_see_app/features/main_screens/profile/service/profile_service.dart';

import '../../../../core/model/place/place_short_for_search.dart';
import '../../../../core/model/routes/route_profile_info.dart';

class ProfileViewModel extends ChangeNotifier{
  ProfileService? profileService;
  UserProfileInfo? userProfileInfo;
  List<RouteProfileInfo> routes = [];
  List<PhotoProfileInfo> photos = [];
  List<PlaceShortForSearch> placesForSearch = [];
  bool isLoading = false;
  bool isError = false;

  List<PhotoFullInfo> get photoFullInfo => photos.map((photo) => photo.toFullInfo()).toList();

  void update(ProfileService service) {
    profileService = service;
    notifyListeners();
  }

  Future<void> loadUser() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      userProfileInfo = (await profileService?.loadUserInfo())!;
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRoutes() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      routes = (await profileService?.loadRoutes())!;
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPhotos() async {
    try {
      isLoading = true;
      isError = false;
      notifyListeners();

      photos = (await profileService?.loadPhotos())!;
      if (userProfileInfo != null) {
        for (var i = 0; i < photos.length; ++i) {
          photos[i] = photos[i].copyWith(
            userName: userProfileInfo!.nickname
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? buildUrlForRouteImg(int index) {
    if (index < 0 || index >= routes.length) return null;

    final route = routes[index];
    final points = route.path;
    final centerPoint = _getCenterOfRouteImg(points);
    final zoom = _getZoom(points);
    final path = points.map((p) => "${p.latitude},${p.longitude}").join(",");
    final startPoint = points.first;
    final endPoint = points.last;

    return "https://static.maps.2gis.com/2.0?"
        "s=190x190"
        "&z=$zoom"
        "&ls=$path~w:5~c:001ADC"
        "&pt=${startPoint.latitude},${startPoint.longitude}~k:c~n:1"
        "&pt=${endPoint.latitude},${endPoint.longitude}~k:c~n:2"
        "&c=${centerPoint.latitude},${centerPoint.longitude}"
        "&key=${AppConfig.twoGisApiKey}";
  }

  Point _getCenterOfRouteImg(List<Point> path) {
    final minLat = path.map((p) => p.latitude).reduce((a,b) => min(a, b));
    final maxLat = path.map((p) => p.latitude).reduce((a,b) => max(a, b));
    final minLon = path.map((p) => p.longitude).reduce((a,b) => min(a, b));
    final maxLon = path.map((p) => p.longitude).reduce((a,b) => max(a, b));

    final centerLat = (minLat + maxLat) / 2;
    final centerLon = (minLon + maxLon) / 2;

    return Point(latitude: centerLat, longitude: centerLon);
  }

  int _getZoom(List<Point> path) {
    final minLat = path.map((p) => p.latitude).reduce((a,b) => min(a, b));
    final maxLat = path.map((p) => p.latitude).reduce((a,b) => max(a, b));
    final minLon = path.map((p) => p.longitude).reduce((a,b) => min(a, b));
    final maxLon = path.map((p) => p.longitude).reduce((a,b) => max(a, b));

    final latDiff = maxLat - minLat;
    final lonDiff = maxLon - minLon;
    final maxDiff = max(latDiff, lonDiff);

    if (maxDiff < 0.005) return 13;
    if (maxDiff < 0.02) return 12;
    if (maxDiff < 0.05) return 11;

    return 10;
  }

  void logout() {
    profileService?.logout();
    notifyListeners();
  }

  Future<RouteModel?> getRouteById(int routeId) async {
    try {
      final route = await profileService?.getRouteById(routeId);
      return route;
    } catch(e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  Future<void> preloadPlaces() async {
    try {
      placesForSearch = await profileService!.getPlacesForSearch();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> uploadPhoto(PlaceShortForSearch place, XFile image) async {
    final tempPhoto = _buildTempPhoto(image, place);
    photos.add(tempPhoto);
    notifyListeners();

    try {
      var uploadedPhoto = await profileService?.uploadPhoto(place.id, image);
      uploadedPhoto = uploadedPhoto?.copyWith(
        userName: userProfileInfo?.nickname,
        createdAt: DateTime.now()
      );

      final index = photos.indexOf(tempPhoto);
      if (index != -1 && uploadedPhoto != null) {
        photos[index] = uploadedPhoto;
      }
    } catch (e) {
        photos.remove(tempPhoto);
        throw Exception("Ошибка при загрузке фото");
    } finally {
      notifyListeners();
    }
  }

  PhotoProfileInfo _buildTempPhoto(XFile image, PlaceShortForSearch place) {
    return PhotoProfileInfo(
        id: DateTime.now().millisecondsSinceEpoch,
        imageUrl: image.path,
        place: place,
        userName: userProfileInfo?.nickname,
        createdAt: DateTime.now()
    );
  }
  
  bool hasRouteInList(int routeId) {
    return routes.any((route) => route.id==routeId);
  }
  
  void addRoute(RouteProfileInfo route) {
    if (hasRouteInList(route.id)) return;
    routes.add(route);
    notifyListeners();
  }

  void editRoute(RouteProfileInfo newRoute) {
    final index = routes.indexWhere((route) => route.id == newRoute.id);
    if (index == -1) return;

    routes[index] = newRoute;
    notifyListeners();
  }
}