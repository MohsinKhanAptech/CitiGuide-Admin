import 'package:citiguide_admin/controllers/password_controller.dart';
import 'package:citiguide_admin/components/password_field.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordController());

    TextEditingController newPasswordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 240,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Reset Password',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Reset app password using master password.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 24),
                    PasswordField(
                      controller: controller.masterPasswordController,
                      labelText: 'Master Password',
                      autofocus: true,
                    ),
                    SizedBox(height: 24),
                    PasswordField(
                      controller: newPasswordController,
                      labelText: 'New Password',
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        controller.resetPassword(newPasswordController.text);
                        newPasswordController.clear();
                      },
                      child: const Text('Confirm'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: Get.back,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
