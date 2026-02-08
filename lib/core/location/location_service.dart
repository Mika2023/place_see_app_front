import 'package:place_see_app/core/permission/permission_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final PermissionService permissionService;

  LocationService(this.permissionService);

  Future<Position?> getCurrentPosition() async {
    bool hasPermission = await permissionService.checkLocationPermission();

    if (!hasPermission) {
      return null;
    }

    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
    ));
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
