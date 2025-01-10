import 'package:citiguide_admin/controllers/password_controller.dart';
import 'package:citiguide_admin/components/password_field.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key, required this.verify});
  final VoidCallback verify;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordController(verify: verify));

    void masterPasswordDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Master Password.'),
            content: PasswordField(
              controller: controller.masterPasswordController,
              labelText: 'Master Password',
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.verifyMasterPassword();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return CircularProgressIndicator();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Password',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 240,
                    ),
                    child: PasswordField(
                      controller: controller.passwordController,
                      autofocus: true,
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: masterPasswordDialog,
                    child: Text('Use Master Password'),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.verifyPassword,
                    child: const Text('Confirm'),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
