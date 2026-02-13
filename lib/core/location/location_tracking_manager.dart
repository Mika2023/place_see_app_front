import 'dart:async';

import 'package:place_see_app/core/api/user_location_api.dart';
import 'package:place_see_app/core/location/location_service.dart';

class LocationTrackingManager {
  final UserLocationApi userLocationApi;
  final LocationService locationService;

  LocationTrackingManager(
      this.locationService,
      this.userLocationApi
  );

  StreamSubscription? _subscription;

  Future<void> startLocationTracking() async {
    _subscription?.cancel();

    _subscription = locationService.getPositionStream().listen((position) {
      userLocationApi.updateLocation(position.latitude, position.longitude);
    });
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }
}