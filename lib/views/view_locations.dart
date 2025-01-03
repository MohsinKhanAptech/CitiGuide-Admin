import 'package:citiguide_admin/main.dart';
import 'package:citiguide_admin/controllers/locationcontroller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ViewLocations extends StatelessWidget {
  const ViewLocations({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
    var locals = controller.locationsSnap;
    TextEditingController textController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Locations.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.locationsList.isEmpty) {
                  return const Center(
                    child: Text('No data found...'),
                  );
                } else {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: locals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                '${locals[index].id} >',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Locaiton.'),
                      content: TextField(
                        controller: textController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Locaiton Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('+ Add Location'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Get.to(const MainView()),
              child: const Text('< Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
