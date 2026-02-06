import 'package:flutter/material.dart';
import 'package:place_see_app/ui/enum/app_input_state.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

class AppInputWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final AppInputState state;
  final TextEditingController? controller;
  final bool obscureText;

  const AppInputWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.state = AppInputState.normal,
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: _textStyleByState(context),
      decoration: InputDecoration(
        hintText: hint,
        border: Theme
            .of(context)
            .inputDecorationTheme
            .border,
        isDense: true,
      ),
    );
  }

  TextStyle _textStyleByState(BuildContext context) {
    final base = Theme
        .of(context)
        .textTheme
        .labelMedium!;

    return base.copyWith(
      color: textColor,
    );
  }

  Color get textColor {
    switch(state) {
      case AppInputState.normal:
        return AppColors.secondary;
      case AppInputState.error:
        return AppColors.accentTwo;
      case AppInputState.success:
        return AppColors.successGreen;
    }
  }
}