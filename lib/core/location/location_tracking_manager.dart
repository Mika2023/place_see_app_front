import 'dart:async';

import 'package:geolocator/geolocator.dart';
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

  final _positionController = StreamController<Position>.broadcast();
  Stream<Position> get positionStream => _positionController.stream;

  Future<void> startLocationTracking() async {
    await _subscription?.cancel();

    final currentPos = await locationService.getCurrentPosition();
    if (currentPos != null && !_positionController.isClosed) {
      _positionController.add(currentPos);
    }

    _subscription = locationService.getPositionStream().listen((position) {
        userLocationApi.updateLocation(position.latitude, position.longitude);
        if (!_positionController.isClosed) {
          _positionController.add(position);
        }
    });
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _positionController.close();
  }
}