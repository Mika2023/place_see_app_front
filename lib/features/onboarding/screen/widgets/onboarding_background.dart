import 'package:flutter/cupertino.dart';
import 'package:place_see_app/ui/enum/app_circle_state.dart';
import 'package:place_see_app/ui/widget/decoration/custom_circle.dart';

class OnboardingBackground extends StatelessWidget {

  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned(
          left: 200,
          top: 67,
          child: CustomCircle(),
        ),
        Positioned(
          left: -77,
          top: 406,
          child: CustomCircle(state: AppCircleState.error,),
        ),
      ],
    );
  }
}
