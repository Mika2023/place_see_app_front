import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';

class LoginViewModel extends ChangeNotifier{
  final AuthService authService;

  bool isLoading = false;
  String? error;

  LoginViewModel(this.authService);

  Future<void> login(String nickname, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await authService.login(nickname, password);
    } catch(e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}