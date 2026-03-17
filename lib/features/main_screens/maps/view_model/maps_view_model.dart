import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:place_see_app/core/location/location_tracking_manager.dart';
import 'package:place_see_app/core/mapper/routes/route_model_mapper.dart';
import 'package:place_see_app/core/model/place/place_short_for_search.dart';
import 'package:place_see_app/core/model/routes/route_model.dart';
import 'package:place_see_app/core/model/routes/route_transport_type_enum.dart';
import 'package:place_see_app/core/utils/point_utils.dart';
import 'package:place_see_app/features/main_screens/maps/service/maps_service.dart';
import 'package:place_see_app/features/main_screens/profile/view_model/profile_view_model.dart';

import '../../../../core/location/location_service.dart';

class MapsViewModel extends ChangeNotifier {
  MapsService? mapsService;
  LocationTrackingManager? locationTrackingManager;
  LocationService? locationService;
  ProfileViewModel? profileViewModel;
  RouteModel? route;
  bool isLoading = false;
  bool isError = false;
  bool isEmptyRouteNormal = true;
  bool isNavigationMode = false;
  bool isRouteCompleted = false;
  bool isFromProfile = false;
  bool wasEdited = false;
  LatLng? userPosition;
  List<LatLng> remainingRoute = [];
  double _remainingDistance = 0;
  List<PlaceShortForSearch> placesForSearch = [];

  StreamSubscription? _positionSub;
  
  LatLng get beginOfPath {
    if (isEmptyRouteNormal || route == null || route!.path.isEmpty) return LatLng(55.754646, 37.621467);
    return PointUtils.toLatLngFromPoint(route!.path.first);
  }

  LatLng? get endOfPath {
    if (isEmptyRouteNormal || route == null || route!.path.isEmpty) return null;
    return PointUtils.toLatLngFromPoint(route!.path.last);
  }

  List<LatLng> get polylines {
    if (isEmptyRouteNormal || route == null || route!.path.isEmpty) return [];
    return route!.path.map((p) => PointUtils.toLatLngFromPoint(p)).toList();
  }

  String get totalDistance {
    if (route == null || route!.totalDistance == 0) return '';

    final distance = route!.totalDistance;
    return formatDistance(distance);
  }

  String get remainingDistance {
    if (remainingRoute.isEmpty || !isNavigationMode || _remainingDistance == 0) return totalDistance;

    return formatDistance(_remainingDistance.toInt());
  }

  void setRoute(RouteModel anotherRoute) {
    route = anotherRoute;
    isEmptyRouteNormal = false;
    isError = false;
    _remainingDistance = 0;
    remainingRoute = [];
    isRouteCompleted = false;
    wasEdited = false;
    isFromProfile = true;
    notifyListeners();
  }

  String formatDistance(int distance) {
    int km = distance ~/ 1000;
    int m = distance % 1000;

    if (km > 0) return '$km,$m км';
    return '$m м';
  }

  void update(MapsService service, LocationTrackingManager manager, LocationService location, ProfileViewModel profileVm) {
    mapsService = service;
    locationTrackingManager = manager;
    locationService = location;
    profileViewModel = profileVm;
  }

  void initLocationListener() async {
    if (_positionSub != null) return;

    final current = await locationService?.getCurrentPosition();
    if (current != null) {
      final position = LatLng(current.latitude, current.longitude);
      userPosition = position;
      notifyListeners();
    }

    _positionSub = locationTrackingManager?.positionStream.listen((pos) {
      final position = LatLng(pos.latitude, pos.longitude);
      userPosition = position;

      if (isNavigationMode) updateUserPosition(position);

      notifyListeners();
    });

  }

  Future<void> preloadPlaces() async {
    try {
      placesForSearch = await mapsService!.getPlacesForSearch();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> loadRoute(int? toPlaceId) async {

    if (toPlaceId == null) {
      isEmptyRouteNormal = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return;
    }

    try {
      isEmptyRouteNormal = false;
      isLoading = true;
      isError = false;
      _remainingDistance = 0;
      remainingRoute = [];
      route = null;
      isRouteCompleted = false;
      wasEdited = false;
      isFromProfile = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      route = (await mapsService?.createAndGetRoute(toPlaceId, RouteTransportTypeEnum.walking))!;
      final routeProfileInfo = route!.toProfileInfo();
      profileViewModel?.addRoute(routeProfileInfo);
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
    } finally {
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> editRoute(bool isStartPlace, int placeId) async {

    if (route == null) {
      isError = true;
      notifyListeners();
      return;
    }
    
    try {
      final routeId = route!.id;

      isEmptyRouteNormal = false;
      isLoading = true;
      isError = false;
      _remainingDistance = 0;
      remainingRoute = [];
      route = null;
      isRouteCompleted = false;
      wasEdited = true;
      isFromProfile = false;
      notifyListeners();

      final fromPlaceId = isStartPlace ? placeId : null;
      final toPlaceId = isStartPlace ? null : placeId;

      route = (await mapsService?.editRoute(fromPlaceId, toPlaceId, routeId, RouteTransportTypeEnum.walking))!;
      final routeProfileInfo = route!.toProfileInfo();
      profileViewModel?.editRoute(routeProfileInfo);
    } catch (e) {
      if (kDebugMode) print(e);
      isError = true;
      wasEdited = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void startNavigation() {
    if (route == null) return;

    isNavigationMode = true;
    remainingRoute = List.from(polylines);
    notifyListeners();
  }

  void stopNavigation() {
    isNavigationMode = false;
    isRouteCompleted = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  void updateUserPosition(LatLng position) {
    userPosition = position;

    if (isNavigationMode && remainingRoute.isNotEmpty) {
      _cutPassedRoute(position);
    }
    notifyListeners();
  }

  void _cutPassedRoute(LatLng position) {
    if (remainingRoute.isEmpty) return;

    int closestInd = 0;
    double minDist = double.infinity;

    for (int i = 0; i < remainingRoute.length; i++) {
      final dist = Distance().as(LengthUnit.Meter, position, remainingRoute[i]);
      if (dist < minDist) {
        minDist = dist;
        closestInd = i;
      }
    }

    remainingRoute = remainingRoute.sublist(closestInd);

    double sum = 0;

    for (int i = 0; i < remainingRoute.length - 1; i++) {
      sum += Distance().as(LengthUnit.Meter, remainingRoute[i], remainingRoute[i+1]);
    }

    _remainingDistance = sum;
  }

  String? getFirstPlaceNameFromProfile() {
    if (!isFromProfile || route == null || route!.name == null) return null;

    final name = route!.name!;
    if (name.contains("->")) {
      final indexOfArrow = name.indexOf("->");
      return name.substring(0, indexOfArrow);
    }

    return 'Ваше местоположение';
  }

  String? getLastPlaceNameFromProfile() {
    if (!isFromProfile || route == null || route!.name == null) return null;

    final name = route!.name!;
    if (name.contains("->")) {
      final indexOfArrow = name.indexOf("->");
      return name.substring(indexOfArrow + 2);
    }

    return 'Не определено';
  }
}