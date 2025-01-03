import 'package:citiguide_admin/main.dart';
import 'package:citiguide_admin/controllers/locationcontroller.dart';
import 'package:citiguide_admin/views/view_city.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ViewLocations extends StatelessWidget {
  const ViewLocations({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());
    var locations = controller.locationsSnap;

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
            const Padding(padding: EdgeInsets.all(24), child: Divider()),
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
                    height: 240,
                    child: ListView.builder(
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 240),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    ViewCity(cityName: locations[index].id),
                                  );
                                },
                                child: Text(
                                  '${locations[index].id} >',
                                ),
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
            const Padding(padding: EdgeInsets.all(24), child: Divider()),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Add Locaiton.'),
                      content: TextField(
                        controller: controller.locationController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Locaiton Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.addLocation().then((value) {
                              if (context.mounted) Navigator.pop(context);
                            });
                          },
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
