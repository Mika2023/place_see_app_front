import 'package:geolocator/geolocator.dart';

class PermissionService {

  Future<bool> checkLocationPermission() async {
    final status = await Geolocator.checkPermission();

    if (status == LocationPermission.always || status == LocationPermission.whileInUse) {
      return true;
    } else if (status == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.always || result == LocationPermission.whileInUse;
    }

    return false;
  }
}