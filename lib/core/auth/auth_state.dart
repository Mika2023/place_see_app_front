import 'package:flutter/cupertino.dart';

enum AuthEnum {
  authenticated,
  unauthenticated,
  unknown,
  afterRegistration,
  registration
}

class AuthState extends ValueNotifier<AuthEnum>{
  AuthState(): super(AuthEnum.unknown);

  void setAuthenticated() => value = AuthEnum.authenticated;
  void setUnauthenticated() => value = AuthEnum.unauthenticated;
  void setAfterRegistration() => value = AuthEnum.afterRegistration;
  void setRegistration() => value = AuthEnum.registration;
}