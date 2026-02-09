import 'package:flutter/material.dart';
import 'package:place_see_app/features/auth/view_model/login_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../ui/enum/app_button_style.dart';
import '../../../../ui/widget/app_button.dart';
import '../../../../ui/widget/app_input_widget.dart';
import '../../../../ui/widget/app_text_button.dart';

class LoginContent extends StatelessWidget {

  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 186),

              Text(
                'Вход',
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
                hint: 'Введите пароль',
                state: vm.fieldState,
                onChanged: vm.updatePasswordField,
                obscureText: true,
              ),

              const SizedBox(height: 45),

              AppButton(
                textOnButton: vm.textOnLoginButton,
                onPressed: () => vm.login(),
                buttonStyle: AppButtonStyle.light,
                state: vm.buttonState,
              ),

              const SizedBox(height: 16),

              Center(
                child: AppTextButton(
                  textOnButton: vm.textOnNavigateLink,
                  state: vm.buttonState,
                  onPressed: vm.goToRegistrationPage,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
