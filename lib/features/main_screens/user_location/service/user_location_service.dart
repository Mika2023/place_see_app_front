import 'package:place_see_app/core/local_storage/app_settings.dart';
import 'package:place_see_app/core/permission/permission_service.dart';

class UserLocationService {
  final PermissionService permissionService;
  final AppSettings appSettings;

  UserLocationService(this.permissionService, this.appSettings);

  Future<bool> requestPermission() {
    final granted = permissionService.checkLocationPermission();
    appSettings.setLocationPermitted();
    return granted;
  }

  Future<void> skip() {
    return appSettings.setLocationPermitted();
  }
}