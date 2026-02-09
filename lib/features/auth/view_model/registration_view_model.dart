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
  AppInputState _currentFieldsState = AppInputState.normal;
  AppCircleState _currentCircleState = AppCircleState.normal;

  void updateRegistrationVM(AuthService service, NavigatorService navigation) {
    authService = service;
    navigatorService = navigation;
    notifyListeners();
  }

  AppButtonState get buttonState => _currentState;
  AppInputState get fieldState => _currentFieldsState;
  AppCircleState get circleState => _currentCircleState;
  String get textOnLoginButton => _textOnRegistrationButton;
  String get textOnNavigateLink => _textOnNavigateLink;

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
    notifyListeners();

    try {
      await authService?.register(nickname, email, password);
      _handleSuccess();
    } catch (e) {
      error = e.toString();

      if (kDebugMode) {
        print(error);
      }

      _handleError();
    } finally {
      notifyListeners();
    }
  }

  void goToLoginPage() {
    navigatorService?.pushReplacement(const LoginScreen());
  }

  void _handleSuccess() {
    _currentState = AppButtonState.disabled;
    _currentFieldsState = AppInputState.success;
    _textOnRegistrationButton = "Успешно!";
    _textOnNavigateLink = "Загрузка...";
  }

  void _handleError() {
    _currentCircleState = AppCircleState.error;
    _currentState = AppButtonState.enabled;
    _currentFieldsState = AppInputState.error;
    _textOnNavigateLink = "Пользователь с такой почтой уже существует! Войти в свой аккаунт";
  }
}