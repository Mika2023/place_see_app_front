import 'package:flutter/material.dart';
import 'package:place_see_app/features/user_location/view_model/user_location_view_model.dart';
import 'package:place_see_app/ui/enum/app_button_state.dart';
import 'package:provider/provider.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../ui/enum/app_button_style.dart';
import '../../../../../ui/widget/app_button.dart';
import '../../../../../ui/widget/app_text_button.dart';

class UserLocationContent extends StatelessWidget {
  const UserLocationContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserLocationViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
        child: Column(
            children: [
              const SizedBox(height: 135),

              Text(
                vm.headingText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: 40,),

              Assets.icons.pin.svg(
                width: 150,
                height: 150,
              ),

              const SizedBox(height: 40,),

              Text(
                vm.bodyText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),

              const SizedBox(height: 24,),

              if (vm.buttonState != AppButtonState.disabled) ...[
                AppButton(
                  textOnButton: 'Разрешить',
                  onPressed: () => vm.requestPermission(),
                  buttonStyle: AppButtonStyle.light,
                  state: vm.buttonState,
                ),

                const SizedBox(height: 16),

                Center(
                  child: AppTextButton(
                    textOnButton: 'Пропустить',
                    state: vm.buttonState,
                    onPressed: vm.skip,
                  ),
                )
              ],
            ],
          ),
        ),
      );
  }
}
