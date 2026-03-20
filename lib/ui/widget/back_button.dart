import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../../gen/assets.gen.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
        onPressed: () => Navigator.of(context).pop(),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(6),
              color: Colors.black.withValues(alpha: 0.09),
              child: Assets.icons.arrowLeft.svg(
                  width: 24,
                  height: 20,
              ),
            ),
          ),
        ),
    );
  }
}
