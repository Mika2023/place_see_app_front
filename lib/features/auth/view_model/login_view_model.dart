import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/enum/app_circle_state.dart';
import 'package:place_see_app/ui/enum/app_input_state.dart';

class LoginViewModel extends ChangeNotifier{
  final AuthService authService;

  String nickname = '';
  String password = '';
  String? error;
  String _textOnLoginButton = "Войти";
  String _textOnNavigateLink = "Зарегистрироваться";
  AppButtonState _currentState = AppButtonState.disabled;
  AppInputState _currentFieldsState = AppInputState.normal;
  AppCircleState _currentCircleState = AppCircleState.normal;

  LoginViewModel(this.authService);

  AppButtonState get buttonState => _currentState;
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
    notifyListeners();

    try {
      await authService.login(nickname, password);
      _handleSuccess();
    } catch(e) {
      error = e.toString();
      _handleError();
    } finally {
      notifyListeners();
    }
  }

  void _handleSuccess() {
    _currentState = AppButtonState.disabled;
    _currentFieldsState = AppInputState.success;
    _textOnLoginButton = "Успешно!";
    _textOnNavigateLink = "Загрузка главного экрана...";
  }

  void _handleError() {
    _currentCircleState = AppCircleState.error;
    _currentState = AppButtonState.enabled;
    _currentFieldsState = AppInputState.error;
    _textOnNavigateLink = error!;
  }
}