import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../../gen/assets.gen.dart';

class BlurCloseButton extends StatelessWidget {
  const BlurCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
        onPressed: () => Navigator.of(context).pop(),
      child: ClipOval(
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
                padding: const EdgeInsets.all(6),
                color: Colors.black.withValues(alpha: 0.05),
                child: Assets.icons.circleCloseLight.svg(
                  width: 35,
                  height: 35
                )
            )
        ),
      ),
    );
  }
}
