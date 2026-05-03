import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/enum/app_button_style.dart';
import '../../../../ui/widget/app_button.dart';
import '../../../../ui/widget/app_input_widget.dart';
import '../../view_model/password_reset_view_model.dart';

class VerifyCodeWidget extends StatefulWidget {
  const VerifyCodeWidget({super.key});

  @override
  State<VerifyCodeWidget> createState() => _VerifyCodeWidgetState();
}

class _VerifyCodeWidgetState extends State<VerifyCodeWidget> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordResetViewModel>();
    final email = vm.currentEmail;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width < 360 ? 18 : 20,
            ),

            children: <TextSpan>[
              const TextSpan(
                text: 'Мы отправили вам письмо с кодом на почту \n',
              ),

              TextSpan(
                text: email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 50),

        AppInputWidget(
          hint: 'Введите код',
          state: vm.currentInputFieldState,
          controller: _codeController,
        ),

        const SizedBox(height: 45),

        AppButton(
            textOnButton: 'Подтвердить код',
            onPressed: () => vm.verifyCode(_codeController.text.trim()),
            buttonStyle: AppButtonStyle.light
        ),
      ],
    );
  }
}
