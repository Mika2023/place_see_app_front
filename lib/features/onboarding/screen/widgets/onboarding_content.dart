import 'package:flutter/material.dart';
import 'package:place_see_app/features/onboarding/view_model/onboarding_view_model.dart';
import 'package:place_see_app/ui/enum/app_button_style.dart';
import 'package:place_see_app/ui/widget/app_button.dart';
import 'package:provider/provider.dart';

class OnboardingContent extends StatelessWidget {

  const OnboardingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<OnboardingViewModel>();

    return SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120,),

              Text(
                'Находите\nкрасоту\nв городе',
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 24,),

              Text(
                'Откройте для себя самые\nфотогеничные уголки',
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              const Spacer(),

              AppButton(
                textOnButton: 'Начать',
                onPressed: () => vm.endOnboarding(),
                buttonStyle: AppButtonStyle.dark,
                state: vm.buttonState,
              ),

              const SizedBox(height: 45,),
            ],
          ),
        ),
    );
  }
}
