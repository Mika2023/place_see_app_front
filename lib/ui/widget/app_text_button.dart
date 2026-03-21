import 'package:flutter/material.dart';

import '../enum/app_button_state.dart';
import '../theme/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final String textOnButton;
  final VoidCallback onPressed;
  final AppButtonState state;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final Widget? postfixIcon;
  final Widget? prefixIcon;

  const AppTextButton({
    super.key,
    required this.textOnButton,
    required this.onPressed,
    this.state = AppButtonState.enabled, this.style, this.overflow, this.maxLines, this.postfixIcon, this.prefixIcon,
  });

  Widget _buildBody() {
    if (postfixIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
            textOnButton,
            textAlign: TextAlign.center,
            style: style,
            overflow: overflow,
            maxLines: maxLines,
          ),
          ),
          const SizedBox(width: 6,),
          postfixIcon!
        ],
      );
    }

    if (prefixIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          prefixIcon!,
          const SizedBox(width: 6,),
          Text(
            textOnButton,
            textAlign: TextAlign.center,
            style: style,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ],
      );
    }

    return Text(
      textOnButton,
      textAlign: TextAlign.center,
      style: style,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled = state == AppButtonState.loading || state == AppButtonState.disabled;
    final base = Theme.of(context).textButtonTheme.style!;

    return TextButton(
      onPressed: isDisabled? null : onPressed,
      style: base.copyWith(
        foregroundColor: WidgetStatePropertyAll(
            isDisabled ? AppColors.secondary : AppColors.disabledDark
        ),
      ),
      child:  _buildBody(),
    );
  }
}