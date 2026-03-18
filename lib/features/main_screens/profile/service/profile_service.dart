import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:place_see_app/core/api/photo_api.dart';
import 'package:place_see_app/core/api/places_api.dart';
import 'package:place_see_app/core/api/route_api.dart';
import 'package:place_see_app/core/api/user_api.dart';
import 'package:place_see_app/core/model/photos/photo_profile_info.dart';
import 'package:place_see_app/core/model/routes/route_model.dart';
import 'package:place_see_app/core/model/routes/route_profile_info.dart';
import 'package:place_see_app/core/model/user/user_profile_info.dart';
import 'package:place_see_app/core/utils/file_service.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';

import '../../../../core/model/place/place_short_for_search.dart';

class ProfileService {
  final UserApi userApi;
  final RouteApi routeApi;
  final PhotoApi photoApi;
  final PlacesApi placesApi;
  final AuthService authService;

  ProfileService(this.userApi, this.routeApi, this.photoApi, this.authService, this.placesApi);

  Future<UserProfileInfo> loadUserInfo() async {
    final rawUser = await userApi.getUserProfileInfo();

    return UserProfileInfo.fromJson(rawUser);
  }

  Future<List<PhotoProfileInfo>> loadPhotos() async {
    final rawPhotos = await photoApi.getPhotosByUser();

    if (rawPhotos.isEmpty) return [];

    return rawPhotos.map((rawPhoto) {
      return PhotoProfileInfo.fromJson(rawPhoto);
    }).toList();
  }

  Future<List<RouteProfileInfo>> loadRoutes() async {
    final rawRoutes = await routeApi.getRoutesForUser();

    if (rawRoutes.isEmpty) return [];

    return rawRoutes.map((rawRoute) {
      return RouteProfileInfo.fromJson(rawRoute);
    }).toList();
  }

  Future<RouteModel> getRouteById(int routeId) async {
    final rawRoute = await routeApi.getRouteById(routeId);

    if (rawRoute.isEmpty) throw Exception('Ответ от апи пришел пустой!');

    return RouteModel.fromJson(rawRoute);
  }

  Future<List<PlaceShortForSearch>> getPlacesForSearch() async {
    final rawPlaces = await placesApi.getPlacesForSearch();

    if (rawPlaces.isEmpty) return [];

    return rawPlaces.map((place) => PlaceShortForSearch.fromJson(place)).toList();
  }

  Future<PhotoProfileInfo> uploadPhoto(int placeId, XFile image) async {
    final finalImage = (await FileService.compressImage(image)) ?? File(image.path);

    final rawPhoto = await photoApi.createPhoto(placeId, finalImage);

    if (rawPhoto.isEmpty) throw Exception('Ответ от апи пришел пустой!');

    return PhotoProfileInfo.fromJson(rawPhoto);
  }

  Future<UserProfileInfo> editProfile(String? newNickname, XFile? image) async {
    final finalImage = image != null ? ((await FileService.compressImage(image)) ?? File(image.path)) : null;

    final rawUser = await userApi.editUserProfileInfo(finalImage, newNickname);

    if (rawUser.isEmpty) throw Exception('Ответ от апи пришел пустой!');

    return UserProfileInfo.fromJson(rawUser);
  }

  void logout() {
    authService.logout();
  }
}