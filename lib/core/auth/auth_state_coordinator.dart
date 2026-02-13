import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/core/local_storage/app_settings.dart';
import 'package:place_see_app/core/location/location_tracking_manager.dart';

class AuthStateCoordinator {
  final AuthState authState;
  final LocationTrackingManager locationTrackingManager;
  final AppSettings appSettings;

  AuthStateCoordinator(this.authState, this.locationTrackingManager, this.appSettings) {
    authState.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (authState.value == AuthEnum.authenticated && appSettings.getIsLocationPermitted()) {
      locationTrackingManager.startLocationTracking();
    } else {
      locationTrackingManager.stopTracking();
    }
  }

  void dispose() {
    authState.removeListener(_onAuthStateChanged);
    locationTrackingManager.stopTracking();
  }
}