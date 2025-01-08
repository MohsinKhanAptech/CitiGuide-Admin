import 'package:citiguide_admin/utils/constants.dart';
import 'package:citiguide_admin/views/update_password_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Settings.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 42),
                ElevatedButton(
                  onPressed: () => Get.to(const UpdatePasswordView()),
                  child: const Text('Change Password >'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => changeTheme(),
                  child: const Text('Change Theme >'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: Get.back,
                  child: const Text('< Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
