import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/view_model/registration_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../ui/widget/decoration/custom_circle.dart';

class RegistrationBackground extends StatelessWidget {
  const RegistrationBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegistrationViewModel>();

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: 67,
            top: 718,
            child: CustomCircle(state: vm.circleState,),
          ),
        ],
      ),
    );
  }
}
