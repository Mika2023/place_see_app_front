import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/ui/enum/app_circle_state.dart';
import 'package:place_see_app/ui/enum/app_input_state.dart';

enum PasswordResetStep {
  requestCode,
  enterCode,
  changePassword
}

class PasswordResetViewModel extends ChangeNotifier{
  final AuthService _authService;

  AppCircleState circleState = AppCircleState.normal;
  AppInputState currentInputFieldState = AppInputState.normal;
  bool isLoading = false;
  bool isError = false;
  String errorText = '';
  PasswordResetStep currentStep = PasswordResetStep.requestCode;
  int userId = -1;
  String verificationCode = '';
  String currentEmail = '';
  String textOnNavigateLink = "Войти в свой аккаунт";

  PasswordResetViewModel(this._authService);

  Future<void> requestCodeToChangePassword(String toEmail) async {
    if (toEmail.isEmpty) return;

    try {
      _isValidEmail(toEmail);

      isLoading = true;
      notifyListeners();

      final codeDto = await _authService.sendCodeToChangePassword(toEmail);
      userId = codeDto.userId;
      verificationCode = codeDto.code;
      currentEmail = toEmail;

      currentStep = PasswordResetStep.enterCode;
      resetState();
    } catch (e) {
      errorText = e.toString().replaceFirst("Exception:", '');
      _handleError();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void verifyCode(String code) {
    if (code.isEmpty || code.length < 6) return;

    if (code.compareTo(verificationCode) != 0) {
      errorText = "Код неверный!";
      _handleError();
    } else {
      currentStep = PasswordResetStep.changePassword;
      resetState();
    }

    notifyListeners();
  }

  Future<bool> resetPassword(String newPassword, String confirmationPassword) async {
    if (newPassword.isEmpty) return false;

    try {
      _validateMatchingPasswords(newPassword, confirmationPassword);

      isLoading = true;
      notifyListeners();

      if (userId == -1) throw Exception("Кажется, произошла ошибка. Попробуйте снова или обратитесь в поддержку");

      await _authService.changePasswordAndLogin(userId, newPassword);

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      errorText = e.toString().replaceFirst("Exception:", '');
      _handleError();

      isLoading = false;
      notifyListeners();

      return false;
    }
  }

  void resetState() {
    isError = false;
    circleState = AppCircleState.normal;
    errorText = '';
    isLoading = false;
    currentInputFieldState = AppInputState.normal;
    textOnNavigateLink = "Войти в свой аккаунт";

    notifyListeners();
  }

  void resetFullState() {
    userId = -1;
    currentEmail = '';
    verificationCode = '';

    resetState();
  }

  void _handleError() {
    isError = true;
    circleState = AppCircleState.error;
    currentInputFieldState = AppInputState.error;
    textOnNavigateLink = "$errorText\nВойти в свой аккаунт";
  }

  void _isValidEmail(String toEmail) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(toEmail)) throw Exception("Почта введена неправильно");
  }

  void _validateMatchingPasswords(String newPassword, String confirmationPassword) {
    if (newPassword.length < 8) throw Exception("Пароль должен содержать минимум 8 символов!");

    if (newPassword.compareTo(confirmationPassword) != 0) {
      throw Exception("Пароли не совпадают!");
    }
  }
}