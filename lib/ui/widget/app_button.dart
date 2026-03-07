import 'package:flutter/material.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:place_see_app/ui/theme/app_colors.dart';
import 'package:place_see_app/ui/widget/stateful/pressable_widget.dart';

import '../enum/app_button_style.dart';

class AppButton extends StatelessWidget {
  final String textOnButton;
  final VoidCallback onPressed;
  final AppButtonStyle buttonStyle;
  final AppButtonState state;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.textOnButton,
    required this.onPressed,
    this.buttonStyle = AppButtonStyle.light,
    this.state = AppButtonState.enabled,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = state == AppButtonState.loading || state == AppButtonState.disabled;

    return PressableWidget(
        onPressed: isDisabled? null : onPressed,
        child: ElevatedButton(
            onPressed: isDisabled? null : onPressed,
            style: _styleByVariant(context, isDisabled),
            child: _content(),
        ),
    );
  }

  ButtonStyle _styleByVariant(BuildContext context, bool isDisabled) {
    final base = Theme.of(context).elevatedButtonTheme.style!;

    return base.copyWith(
      backgroundColor: WidgetStatePropertyAll(isDisabled? _disabledBackgroundColor : _backgroundColor),
      foregroundColor: WidgetStatePropertyAll(_foregroundColor),
    );
  }

  Color get _backgroundColor {
    switch (buttonStyle) {
      case AppButtonStyle.light:
        return AppColors.accentOne;
      case AppButtonStyle.dark:
        return AppColors.secondary;
    }
  }

  Color get _disabledBackgroundColor {
    switch (buttonStyle) {
      case AppButtonStyle.light:
        return AppColors.disabledLight;
      case AppButtonStyle.dark:
        return AppColors.disabledDark;
    }
  }

  Color get _foregroundColor {
    switch (buttonStyle) {
      case AppButtonStyle.light:
        return AppColors.secondary;
      case AppButtonStyle.dark:
        return AppColors.primary;
    }
  }

  Widget _content() {
    if (state == AppButtonState.loading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2,),
      );
    }

    if (icon == null) return Text(textOnButton);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(textOnButton),
        const SizedBox(width: 12,),
        icon!
      ],
    );
  }
}