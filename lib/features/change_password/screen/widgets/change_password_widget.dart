import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../ui/enum/app_button_style.dart';
import '../../../../ui/widget/app_button.dart';
import '../../../../ui/widget/app_input_widget.dart';
import '../../view_model/password_reset_view_model.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _confirmationPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _confirmationPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordResetViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        AppInputWidget(
          hint: 'Введите новый пароль',
          state: vm.currentInputFieldState,
          controller: _passwordController,
          obscureText: isPasswordObscured,
          postfixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordObscured = !isPasswordObscured;
              });
            },
            child: isPasswordObscured ? Assets.icons.openedEye.svg(
                width: 17,
                height: 17
            ) : Assets.icons.closedEye.svg(
                width: 27,
                height: 27
            ),
          ),
        ),

        const SizedBox(height: 24),

        AppInputWidget(
          hint: 'Подтвердите пароль',
          state: vm.currentInputFieldState,
          controller: _confirmationPasswordController,
          obscureText: isConfirmPasswordObscured,
          postfixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isConfirmPasswordObscured = !isConfirmPasswordObscured;
              });
            },
            child: isConfirmPasswordObscured ? Assets.icons.openedEye.svg(
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
          textOnButton: 'Восстановить пароль',
          onPressed: () async {
            final success = await vm.resetPassword(_passwordController.text.trim(), _confirmationPasswordController.text.trim());
            if (success && mounted) {
              Navigator.of(context).pop();
            }
          },
          buttonStyle: AppButtonStyle.light
        ),
      ],
    );
  }
}
