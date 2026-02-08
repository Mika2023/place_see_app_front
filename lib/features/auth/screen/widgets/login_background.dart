import 'package:flutter/cupertino.dart';
import 'package:place_see_app/features/auth/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../ui/widget/decoration/custom_circle.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

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
