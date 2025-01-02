// ignore_for_file: prefer_const_constructors

import 'package:citiguide_admin/controllers/addhotelcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddhotelScreen extends StatelessWidget {
  const AddhotelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(hotelcontroller());
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
              controller: controller.hotelController,
              decoration: const InputDecoration(hintText: "Hotel Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  controller.addlocation();
                },
                child: const Text("Add Hotel"))
          ],
        ),
      ),
    );
  }
}
