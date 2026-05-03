import 'package:flutter/material.dart';
import 'package:place_see_app/features/change_password/view_model/password_reset_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../ui/widget/decoration/custom_circle.dart';

class Background extends StatelessWidget{
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordResetViewModel>();

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