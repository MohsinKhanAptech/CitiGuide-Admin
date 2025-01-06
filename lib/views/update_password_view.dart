import 'package:citiguide_admin/controllers/password_controller.dart';
import 'package:citiguide_admin/components/my_text_field.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UpdatePasswordView extends StatelessWidget {
  const UpdatePasswordView({super.key});

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
                      'Enter Password',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    MyTextField(
                      controller: controller.passwordController,
                      labelText: 'Old Password',
                      obscureText: true,
                      suffixIcon: Icons.visibility,
                      suffixIconActive: Icons.visibility_off,
                    ),
                    SizedBox(height: 24),
                    MyTextField(
                      controller: newPasswordController,
                      labelText: 'New Password',
                      obscureText: true,
                      suffixIcon: Icons.visibility,
                      suffixIconActive: Icons.visibility_off,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        controller.updatePassword(newPasswordController.text);
                        newPasswordController.clear();
                      },
                      child: const Text('Confirm'),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Get.back(),
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
