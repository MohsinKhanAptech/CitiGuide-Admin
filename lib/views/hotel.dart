import 'package:citiguide_admin/controllers/Resturantcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Addhotel extends StatelessWidget {
  // final Map list;
  final String mylist;
  const Addhotel({super.key, required this.mylist});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(Mainscreencontroller());
    final procontroller = Get.put(Resturantcontroller());

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
            Text(
              mylist,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: procontroller.productNameController,
              decoration: const InputDecoration(hintText: "Product Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: procontroller.productPriceController,
              decoration: const InputDecoration(hintText: "Product Price"),
            ),
            const SizedBox(
              height: 30,
            ),

            // Adding upload image work

            Obx(() {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await procontroller.pickImage();
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: procontroller.imageFile.value != null
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
                        child: procontroller.imageFile.value != null
                            ? Image.file(
                                procontroller.imageFile.value!,
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
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    procontroller.selectedFileName.value.isNotEmpty
                        ? procontroller.selectedFileName.value
                        : "tap to select the image",
                    style: const TextStyle(fontSize: 15),
                  )
                ],
              );
            }),

            // ending upload image work

            ElevatedButton(
                onPressed: () {
                  procontroller.addProduct(mylist);
                },
                child: const Text("Add Product"))
          ],
        ),
      ),
    );
  }
}
