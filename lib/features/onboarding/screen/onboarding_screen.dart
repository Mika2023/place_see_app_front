import 'package:flutter/material.dart';
import 'package:place_see_app/features/onboarding/screen/widgets/onboarding_background.dart';
import 'package:place_see_app/features/onboarding/screen/widgets/onboarding_content.dart';

class OnboardingScreen extends StatelessWidget{

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingBackground(),
          OnboardingContent(),
        ],
      ),
    );
  }
}