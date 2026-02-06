import 'package:hive/hive.dart';

class AppSettings {
  static const _onboardingName = 'completed_onboarding';
  final Box settingsBox;

  AppSettings(this.settingsBox);

  bool getIsOnboardingCompleted() =>
      settingsBox.get(_onboardingName, defaultValue: false);
  Future<void> setOnboardingCompleted() =>
      settingsBox.put(_onboardingName, true);
}