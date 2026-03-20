import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:place_see_app/core/api/user_location_api.dart';
import 'package:place_see_app/core/location/location_service.dart';

class LocationTrackingManager {
  final UserLocationApi userLocationApi;
  final LocationService locationService;
  DateTime? _lastSent;

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

    _subscription = locationService.getPositionStream().listen((position) async {
      final now = DateTime.now();

      if (_lastSent == null || now.difference(_lastSent!) > const Duration(seconds: 10)) {
        _lastSent = now;

        try {
          await userLocationApi.updateLocation(
              position.latitude, position.longitude);
        } catch (e) {
          debugPrint("ошибка отправки координат: $e");
        }
      }

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