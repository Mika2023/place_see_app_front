import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/screen/registration_screen.dart';
import 'package:place_see_app/features/onboarding/service/onboarding_service.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/navigator/navigator_service.dart';
import 'package:place_see_app/ui/widget/app_button.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingService? _service;
  NavigatorService? navigatorService;

  AppButtonState _buttonState = AppButtonState.enabled;

  AppButtonState get buttonState => _buttonState;

  void updateService(OnboardingService service, NavigatorService navigator) {
    _service = service;
    navigatorService = navigator;
    notifyListeners();
  }

  Future<void> endOnboarding() async {
    _buttonState = AppButtonState.loading;
    notifyListeners();

    await _service?.completeOnboarding();
    _buttonState = AppButtonState.disabled;
    notifyListeners();
  }

  String get serviceState => _service == null ? 'Загрузка' : 'Все норм';
}