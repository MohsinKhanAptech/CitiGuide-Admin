import 'package:citiguide_admin/controllers/password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    TextField(
                      controller: controller.passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Old Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        controller.updatePassword(newPasswordController.text);
                        newPasswordController.clear();
                      },
                      child: const Text('Confirm'),
                    ),
                    SizedBox(height: 24),
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
