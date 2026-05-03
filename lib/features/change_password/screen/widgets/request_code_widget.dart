import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../ui/enum/app_button_style.dart';
import '../../../../ui/widget/app_button.dart';
import '../../../../ui/widget/app_input_widget.dart';
import '../../view_model/password_reset_view_model.dart';

class RequestCodeWidget extends StatefulWidget {
  const RequestCodeWidget({super.key});

  @override
  State<RequestCodeWidget> createState() => _RequestCodeWidgetState();
}

class _RequestCodeWidgetState extends State<RequestCodeWidget> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordResetViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Мы отправим вам письмо\n с кодом на почту',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: MediaQuery.of(context).size.width < 360 ? 18 : 20
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 50),

        AppInputWidget(
          hint: 'Введите Email',
          state: vm.currentInputFieldState,
          controller: _emailController,
        ),

        const SizedBox(height: 45),

        AppButton(
          textOnButton: 'Получить код',
          onPressed: () => vm.requestCodeToChangePassword(_emailController.text.trim()),
          buttonStyle: AppButtonStyle.light
        ),
      ],
    );
  }
}



