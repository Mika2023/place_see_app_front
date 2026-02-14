import 'package:flutter/cupertino.dart';

import '../../../../../ui/widget/decoration/custom_circle.dart';

class UserLocationBackground extends StatelessWidget {
  const UserLocationBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: 85,
            top: -126,
            child: CustomCircle(),
          ),
        ],
      ),
    );
  }
}
