import 'package:flutter/cupertino.dart';
import '../service/auth_service.dart';

class RegistrationViewModel extends ChangeNotifier{
  final AuthService authService;

  bool isLoading = false;
  String? error;

  RegistrationViewModel(this.authService);

  Future<void> register(String nickname, String email, String password) async {
    try {
      isLoading = true;
      notifyListeners();

      await authService.register(nickname, email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}