import 'package:flutter/cupertino.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../../gen/assets.gen.dart';

class AddPhotoButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddPhotoButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PressableWidget(
        onPressed: onPressed,
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.additionalOne
        ),
        child: Center(
          child: Assets.icons.plus.svg(
            height: 40,
            width: 40
          ),
        ),
      ),
    );
  }
}
