import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:place_see_app/ui/enum/app_circle_state.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

class CustomCircle extends StatelessWidget {
  final double size;
  final AppCircleState state;
  final double blurCoef;

  const CustomCircle({
    super.key,
    this.size = 297,
    this.state = AppCircleState.normal,
    this.blurCoef = 200,
  });

  @override
  Widget build(BuildContext context) {
    bool isError = state == AppCircleState.error;
    Color color = isError? AppColors.darkRed : AppColors.accentOne;

    return SizedBox(
      width: size,
      height: size,
      child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: blurCoef,
            sigmaY: blurCoef,
          ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 1.0),
                color.withValues(alpha: 0.8),
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.0),
              ],
              stops: const [0.0, 0.8, 0.9, 1.0],
            ),
          ),
        ),
      ),
    );
  }

}