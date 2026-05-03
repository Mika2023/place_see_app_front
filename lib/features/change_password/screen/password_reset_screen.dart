import 'package:flutter/material.dart';
import 'package:place_see_app/features/change_password/screen/widgets/background.dart';
import 'package:place_see_app/features/change_password/screen/widgets/change_password_widget.dart';
import 'package:place_see_app/features/change_password/screen/widgets/request_code_widget.dart';
import 'package:place_see_app/features/change_password/screen/widgets/verify_code_widget.dart';
import 'package:place_see_app/features/change_password/view_model/password_reset_view_model.dart';
import 'package:provider/provider.dart';

import '../../../ui/widget/app_text_button.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PasswordResetViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Background(),

          SafeArea(
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 22),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 186),

                      Text(
                        'Восстановление\nпароля',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: MediaQuery.of(context).size.width < 360 ? 34 : 38
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 50,),

                      _buildCurrentStepWidget(context, vm.currentStep),

                      const SizedBox(height: 16),

                      Center(
                        child: AppTextButton(
                          textOnButton: vm.textOnNavigateLink,
                          onPressed: () {
                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
          ),

          if (vm.isLoading) ...[
            const ModalBarrier(
              dismissible: false,
              color: Colors.black38,
            ),
            const Center(child: CircularProgressIndicator(),)
          ]

        ],
      ),
    );
  }

  Widget _buildCurrentStepWidget(BuildContext context, PasswordResetStep currentStep) {
    switch(currentStep) {
      case PasswordResetStep.requestCode:
        return const RequestCodeWidget();
      case PasswordResetStep.enterCode:
        return const VerifyCodeWidget();
      case PasswordResetStep.changePassword:
        return const ChangePasswordWidget();
    }
  }
}
