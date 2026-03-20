import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/screen/registration_screen.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/enum/app_circle_state.dart';
import 'package:place_see_app/ui/enum/app_input_state.dart';
import 'package:place_see_app/ui/navigator/navigator_service.dart';

class LoginViewModel extends ChangeNotifier{
  AuthService? authService;
  NavigatorService? navigatorService;

  String nickname = '';
  String password = '';
  String? error;
  String _textOnLoginButton = "Войти";
  String _textOnNavigateLink = "Зарегистрироваться";
  AppButtonState _currentState = AppButtonState.disabled;
  AppInputState _currentFieldsState = AppInputState.normal;
  AppCircleState _currentCircleState = AppCircleState.normal;
  AppButtonState _currentTextButtonState = AppButtonState.enabled;

  void updateLoginVm(AuthService service, NavigatorService navigation) {
    authService = service;
    navigatorService = navigation;
    notifyListeners();
  }

  AppButtonState get buttonState => _currentState;
  AppButtonState get textButtonState => _currentTextButtonState;
  AppInputState get fieldState => _currentFieldsState;
  AppCircleState get circleState => _currentCircleState;
  String get textOnLoginButton => _textOnLoginButton;
  String get textOnNavigateLink => _textOnNavigateLink;

  void updateNicknameField(String value) {
    nickname = value;
    _updateButtonState();
  }

  void updatePasswordField(String value) {
    password = value;
    _updateButtonState();
  }

  void _updateButtonState() {
    if (nickname.isEmpty || password.isEmpty) {
      _currentState = AppButtonState.disabled;
    } else {
      _currentState = AppButtonState.enabled;
    }
    notifyListeners();
  }

  Future<void> login() async {
    if (_currentState != AppButtonState.enabled) return;

    _currentState = AppButtonState.loading;
    _currentTextButtonState = AppButtonState.loading;
    notifyListeners();

    try {
      await authService?.login(nickname, password);
      _handleSuccess();
    } catch(e) {
      error = e.toString();
      _handleError();
    } finally {
      notifyListeners();
    }
  }

  void goToRegistrationPage() {
    resetState();
    authService?.setRegistration();
  }

  void resetState() {
    _currentTextButtonState = AppButtonState.enabled;
    _currentCircleState = AppCircleState.normal;
    _currentFieldsState = AppInputState.normal;
    _currentState = AppButtonState.disabled;
    _textOnLoginButton = "Войти";
    _textOnNavigateLink = "Зарегистрироваться";
  }

  void _handleSuccess() {
    _currentTextButtonState = AppButtonState.disabled;
    _currentState = AppButtonState.disabled;
    _currentFieldsState = AppInputState.success;
    _currentCircleState = AppCircleState.normal;
    _textOnLoginButton = "Успешно!";
    _textOnNavigateLink = "Загрузка главного экрана...";
  }

  void _handleError() {
    _currentTextButtonState = AppButtonState.enabled;
    _currentCircleState = AppCircleState.error;
    _currentState = AppButtonState.enabled;
    _currentFieldsState = AppInputState.error;
    _textOnNavigateLink = "Неверно введены никнейм или пароль!\nЗарегистрироваться";
  }
}