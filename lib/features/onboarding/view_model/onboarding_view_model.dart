import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/screen/registration_screen.dart';
import 'package:place_see_app/features/onboarding/service/onboarding_service.dart';
import 'package:place_see_app/ui/navigator/navigator_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingService? _service;
  NavigatorService? navigatorService;

  void updateService(OnboardingService service, NavigatorService navigator) {
    _service = service;
    navigatorService = navigator;
    notifyListeners();
  }

  Future<void> endOnboarding() async {
    await _service?.completeOnboarding();
    notifyListeners();
  }


  String get serviceState => _service == null ? 'Загрузка' : 'Все норм';
}