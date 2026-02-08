import 'package:flutter/material.dart';
import 'package:place_see_app/features/auth/screen/widgets/login_background.dart';
import 'package:place_see_app/features/auth/screen/widgets/login_content.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          LoginBackground(),
          LoginContent(),
        ],
      ),
    );
  }
}