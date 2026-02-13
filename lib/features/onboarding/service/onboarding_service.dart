import 'package:place_see_app/core/local_storage/app_settings.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';

class OnboardingService {
  final AppSettings appSettings;
  final AuthService authService;

  OnboardingService(this.appSettings, this.authService);

  Future<void> completeOnboarding() async {
    await authService.checkAuth();
    appSettings.setOnboardingCompleted();
  }
}