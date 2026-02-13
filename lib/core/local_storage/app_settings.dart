import 'package:hive/hive.dart';

class AppSettings {
  static const _onboardingName = 'completed_onboarding';
  static const _geolocationPermissionName = 'completed_location_permission';
  final Box settingsBox;

  AppSettings(this.settingsBox);

    bool getIsOnboardingCompleted() =>
        settingsBox.get(_onboardingName, defaultValue: false);
    Future<void> setOnboardingCompleted() =>
        settingsBox.put(_onboardingName, true);

  bool getIsLocationPermitted() =>
      settingsBox.get(_geolocationPermissionName, defaultValue: false);
  Future<void> setLocationPermitted() =>
      settingsBox.put(_geolocationPermissionName, true);
}