import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  Future<bool> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.locationWhenInUse.request();
      return result.isGranted;
    }

    return false;
  }
}