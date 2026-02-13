import 'package:flutter/cupertino.dart';
import 'package:place_see_app/core/auth/auth_state.dart';
import 'package:place_see_app/features/main_screens/user_location/service/user_location_service.dart';

import '../../../../ui/enum/app_button_state.dart';

class UserLocationViewModel extends ChangeNotifier {
  UserLocationService? _userLocationService;
  AuthState? _authState;

  void updateService(UserLocationService service, AuthState authState) {
    _userLocationService = service;
    _authState = authState;
    notifyListeners();
  }

  String _headingText = 'Мы не знаем,\nгде Вы';
  String _bodyText = 'Разрешите доступ к геопозиции';
  AppButtonState _buttonState = AppButtonState.enabled;

  String get headingText => _headingText;
  String get bodyText => _bodyText;
  AppButtonState get buttonState => _buttonState;

  Future<void> requestPermission() async {
    _buttonState = AppButtonState.loading;
    notifyListeners();

    final granted = await _userLocationService?.requestPermission();

    if (granted != null && granted) {
      _handleGrantedTrue();
      notifyListeners();
    } else {
      _handleGrantedFalse();
      notifyListeners();
    }

    _authState?.setAuthenticated();
  }

  Future<void> skip() async {
    await _userLocationService?.skip();
    _handleGrantedFalse();
    notifyListeners();

    _authState?.setAuthenticated();
  }

  void _handleGrantedTrue() {
    _headingText = 'Мы знаем, где Вы!';
    _bodyText = 'Доступ к геопозиции разрешен!';
    _buttonState = AppButtonState.disabled;
  }

  void _handleGrantedFalse() {
    _bodyText = 'Доступ к геопозиции не разрешен';
    _buttonState = AppButtonState.disabled;
  }
}