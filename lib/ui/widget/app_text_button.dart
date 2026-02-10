import 'package:flutter/material.dart';

import '../enum/app_button_state.dart';
import '../theme/app_colors.dart';

class AppTextButton extends StatelessWidget {
  final String textOnButton;
  final VoidCallback onPressed;
  final AppButtonState state;

  const AppTextButton({
    super.key,
    required this.textOnButton,
    required this.onPressed,
    this.state = AppButtonState.enabled,
  });

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
      child: Text(
          textOnButton,
        textAlign: TextAlign.center,
      ),
    );
  }
}