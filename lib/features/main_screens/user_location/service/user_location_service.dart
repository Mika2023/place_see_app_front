import 'package:dio/dio.dart';
import 'package:place_see_app/core/location/location_service.dart';
import 'package:place_see_app/core/permission/permission_service.dart';

class UserLocationService {
  final Dio dio;
  final LocationService locationService;
  final PermissionService permissionService;

  UserLocationService(this.dio, this.locationService, this.permissionService);

  Future<void> updateLocation(double latitude, double longitude) async {
    await dio.post(
      '/user-location/update-location',
      data: {
        'latitude': latitude,
        'longitude': longitude,
      }
    );
  }

  void startLocationTracking() async {
    final granted = await permissionService.checkLocationPermission();
    if (!granted) return;

    locationService.getPositionStream().listen((position) {
      updateLocation(position.latitude, position.longitude);
    });
  }
}