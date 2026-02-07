import 'package:flutter/material.dart';
import 'package:place_see_app/features/auth/screen/widgets/registration_background.dart';
import 'package:place_see_app/features/auth/screen/widgets/registration_content.dart';

class RegistrationScreen extends StatelessWidget {

  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RegistrationBackground(),
          RegistrationContent(),
        ],
      ),
    );
  }

}