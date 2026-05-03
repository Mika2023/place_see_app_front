import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:place_see_app/features/auth/screen/login_screen.dart';
import 'package:place_see_app/ui/navigator/navigator_service.dart';
import '../../../ui/enum/app_button_state.dart';
import '../../../ui/enum/app_circle_state.dart';
import '../../../ui/enum/app_input_state.dart';
import '../service/auth_service.dart';

class RegistrationViewModel extends ChangeNotifier{
  AuthService? authService;
  NavigatorService? navigatorService;

  String email = '';
  String password = '';
  String nickname = '';
  String? error;
  String _textOnRegistrationButton = "Зарегистрироваться";
  String _textOnNavigateLink = "Войти в свой аккаунт";
  AppButtonState _currentState = AppButtonState.disabled;
  AppButtonState _currentTextButtonState = AppButtonState.enabled;
  AppInputState _currentFieldsState = AppInputState.normal;
  AppCircleState _currentCircleState = AppCircleState.normal;
  bool _isPasswordObscured = true;

  void updateRegistrationVM(AuthService service, NavigatorService navigation) {
    authService = service;
    navigatorService = navigation;
    notifyListeners();
  }

  AppButtonState get buttonState => _currentState;
  AppButtonState get textButtonState => _currentTextButtonState;
  AppInputState get fieldState => _currentFieldsState;
  AppCircleState get circleState => _currentCircleState;
  String get textOnLoginButton => _textOnRegistrationButton;
  String get textOnNavigateLink => _textOnNavigateLink;
  bool get isPasswordObscured => _isPasswordObscured;

  void updateEmailField(String value) {
    email = value;
    _updateButtonState();
  }

  void updateNicknameField(String value) {
    nickname = value;
    _updateButtonState();
  }

  void updatePasswordField(String value) {
    password = value;
    _updateButtonState();
  }

  void _updateButtonState() {
    if (nickname.isEmpty || password.isEmpty || email.isEmpty) {
      _currentState = AppButtonState.disabled;
    } else {
      _currentState = AppButtonState.enabled;
    }
    notifyListeners();
  }

  Future<void> register() async {
    if (_currentState != AppButtonState.enabled) return;

    _currentState = AppButtonState.loading;
    _currentTextButtonState = AppButtonState.loading;
    notifyListeners();

    try {
      await authService?.register(nickname, email, password);
      _handleSuccess();
    } catch (e) {
      error = e.toString().replaceFirst("Exception:", '');

      if (kDebugMode) {
        print(error);
      }

      _handleError();
    } finally {
      notifyListeners();
    }
  }

  void goToLoginPage() {
    _resetState();
    authService?.setLogin();
  }

  void _resetState() {
    _currentCircleState = AppCircleState.normal;
    _currentFieldsState = AppInputState.normal;
    _currentState = AppButtonState.disabled;
    _currentTextButtonState = AppButtonState.enabled;
    _textOnRegistrationButton = "Зарегистрироваться";
    _textOnNavigateLink = "Войти в свой аккаунт";
    _isPasswordObscured = true;
  }

  void _handleSuccess() {
    _currentState = AppButtonState.disabled;
    _currentFieldsState = AppInputState.success;
    _currentTextButtonState = AppButtonState.disabled;
    _currentCircleState = AppCircleState.normal;
    _textOnRegistrationButton = "Успешно!";
    _textOnNavigateLink = "Загрузка...";
  }

  void _handleError() {
    _currentTextButtonState = AppButtonState.enabled;
    _currentCircleState = AppCircleState.error;
    _currentState = AppButtonState.enabled;
    _currentFieldsState = AppInputState.error;
    _textOnNavigateLink = "$error\nВойти в свой аккаунт";
  }

  void togglePasswordObscured() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }
}