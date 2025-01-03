// ignore_for_file: prefer_const_constructors

import 'package:citiguide_admin/controllers/locationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddlocationScreen extends StatelessWidget {
  const AddlocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              "Admin Panel",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: controller.locationController,
              decoration: const InputDecoration(hintText: "Location Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  controller.addlocation();
                },
                child: const Text("Add location"))
          ],
        ),
      ),
    );
  }
}
