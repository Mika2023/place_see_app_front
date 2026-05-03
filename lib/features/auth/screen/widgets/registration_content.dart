import 'package:flutter/material.dart';
import 'package:place_see_app/features/auth/view_model/registration_view_model.dart';
import 'package:place_see_app/ui/widget/app_input_widget.dart';
import 'package:place_see_app/ui/widget/app_text_button.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/enum/app_button_style.dart';
import '../../../../ui/widget/app_button.dart';

class RegistrationContent extends StatelessWidget {

  const RegistrationContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegistrationViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 186),

                    Text(
                      'Регистрация',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    const SizedBox(height: 64,),

                    AppInputWidget(
                      hint: 'Введите никнейм',
                      state: vm.fieldState,
                      onChanged: vm.updateNicknameField,
                    ),

                    const SizedBox(height: 24),

                    AppInputWidget(
                      hint: 'Введите email',
                      state: vm.fieldState,
                      onChanged: vm.updateEmailField,
                    ),

                    const SizedBox(height: 24),

                    AppInputWidget(
                      hint: 'Введите пароль',
                      state: vm.fieldState,
                      onChanged: vm.updatePasswordField,
                      obscureText: vm.isPasswordObscured,
                      postfixIcon: GestureDetector(
                        onTap: () => vm.togglePasswordObscured(),
                        child: vm.isPasswordObscured ? Assets.icons.openedEye.svg(
                            width: 17,
                            height: 17
                        ) : Assets.icons.closedEye.svg(
                            width: 27,
                            height: 27
                        ),
                      ),
                    ),

                    const SizedBox(height: 45),

                    AppButton(
                      textOnButton: vm.textOnLoginButton,
                      onPressed: () => vm.register(),
                      buttonStyle: AppButtonStyle.light,
                      state: vm.buttonState,
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child: AppTextButton(
                        textOnButton: vm.textOnNavigateLink,
                        state: vm.textButtonState,
                        onPressed: vm.goToLoginPage,
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
