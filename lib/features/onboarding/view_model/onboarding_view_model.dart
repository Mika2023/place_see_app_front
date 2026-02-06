import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/onboarding/service/onboarding_service.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingService? _service;

  void updateService(OnboardingService service) {
    _service = service;
    notifyListeners();
  }

  Future<void> endOnboarding() async {
    await _service?.completeOnboarding();
    notifyListeners();
  }


  String get serviceState => _service == null ? 'Загрузка' : 'Все норм';
}