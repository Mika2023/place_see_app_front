import 'package:place_see_app/core/local_storage/app_settings.dart';

class OnboardingService {
  final AppSettings appSettings;

  OnboardingService(this.appSettings);

  Future<void> completeOnboarding() => appSettings.setOnboardingCompleted();
}