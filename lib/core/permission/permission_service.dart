import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static Future<PermissionStatus> checkGalleryPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted || status.isLimited) {
      return PermissionStatus.granted;
    }

    if (status.isDenied) {
      return await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      return PermissionStatus.permanentlyDenied;
    }

    return PermissionStatus.denied;
  }
}