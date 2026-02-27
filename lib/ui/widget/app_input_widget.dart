import 'package:flutter/material.dart';
import 'package:place_see_app/ui/enum/app_input_state.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';

class AppInputWidget extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final AppInputState state;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool obscureText;

  final Widget? prefixIcon;
  final Widget? postfixIcon;

  const AppInputWidget({
    super.key,
    required this.hint,
    this.onChanged,
    this.state = AppInputState.normal,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.postfixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      onChanged: onChanged,
      style: _textStyleByState(context),
      decoration: InputDecoration(
        hintText: hint,
        constraints: const BoxConstraints(
          minHeight: 58,
          maxHeight: 58,
        ),
        border: Theme
            .of(context)
            .inputDecorationTheme
            .border,
        isDense: true,
        prefixIcon: prefixIcon != null ? Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: prefixIcon,
        ) : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 29,
          minHeight: 29,
        ),
        suffixIcon: postfixIcon != null ? Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: postfixIcon,
        ) : null,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 15,
          minHeight: 15,
        )
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