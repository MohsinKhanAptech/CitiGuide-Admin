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
              controller: controller.hotelnameController,
              decoration: const InputDecoration(hintText: "Hotel Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.hoteladdressController,
              decoration: const InputDecoration(hintText: "Hotel Address"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.hotelDescriptionController,
              decoration: const InputDecoration(hintText: "Hotel description"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.hotelLongitudeController,
              decoration: const InputDecoration(hintText: "Hotel Longitude"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: controller.hotelLatitudeController,
              decoration: const InputDecoration(hintText: "Hotel Latitude"),
            ),
            const SizedBox(
              height: 10,
            ),
               TextField(
              controller: controller.hotelratingController,
              decoration: const InputDecoration(hintText: "Hotel Rating"),
            ),
            const SizedBox(
              height: 10,
            ),
            // Adding upload image work

            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await controller.pickImage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: controller.imageFile.value != null
                                ? Colors.greenAccent
                                : Colors.grey,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 10),
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: controller.imageFile.value != null
                            ? Image.file(
                                controller.imageFile.value!,
                                fit: BoxFit.cover,
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                  Text(
                                    "Tap to Select",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.selectedFileName.value.isNotEmpty
                        ? controller.selectedFileName.value
                        : "tap to select the image",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              );
            }),

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
