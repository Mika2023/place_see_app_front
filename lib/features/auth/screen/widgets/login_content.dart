import 'package:flutter/material.dart';
import 'package:place_see_app/features/auth/service/auth_service.dart';
import 'package:place_see_app/features/auth/view_model/login_view_model.dart';
import 'package:place_see_app/features/change_password/screen/password_reset_screen.dart';
import 'package:place_see_app/features/change_password/view_model/password_reset_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
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
        child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 186),

                        Text(
                          'Вход',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headlineLarge,
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
                          onPressed: () => vm.login(),
                          buttonStyle: AppButtonStyle.light,
                          state: vm.buttonState,
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: AppTextButton(
                            textOnButton: vm.textOnNavigateLink,
                            state: vm.textButtonState,
                            onPressed: vm.goToRegistrationPage,
                          ),
                        ),
                      ],
                    ),
                  )
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 60, top: 10),
                child: Center(
                  child: AppTextButton(
                    textOnButton: 'Забыли пароль?',
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) =>
                              ChangeNotifierProvider(
                                create: (context) =>
                                    PasswordResetViewModel(
                                      context.read<AuthService>(),
                                    ),
                                child: const PasswordResetScreen(),
                              )
                      ));
                    },
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }
}
