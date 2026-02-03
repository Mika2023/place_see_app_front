import 'package:flutter/cupertino.dart';

enum AuthEnum {
  authenticated,
  unauthenticated,
  unknown
}

class AuthState extends ValueNotifier<AuthEnum>{
  AuthState(): super(AuthEnum.unknown);

  void setAuthenticated() => value = AuthEnum.authenticated;
  void setUnauthenticated() => value = AuthEnum.unauthenticated;
}