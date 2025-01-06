import 'package:citiguide_admin/controllers/password_controller.dart';
import 'package:citiguide_admin/components/my_text_field.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key, required this.verify});
  final VoidCallback verify;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PasswordController(verify: verify));

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
                    child: MyTextField(
                      controller: controller.passwordController,
                      obscureText: true,
                      labelText: 'Password',
                      suffixIcon: Icons.visibility,
                      suffixIconActive: Icons.visibility_off,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.verifyPassword(),
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
