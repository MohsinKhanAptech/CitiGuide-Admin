import 'package:citiguide_admin/controllers/location_controller.dart';
import 'package:citiguide_admin/views/location_add_view.dart';
import 'package:citiguide_admin/views/location_detail_view.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocationView extends StatelessWidget {
  const LocationView({
    super.key,
    required this.cityID,
    required this.cityName,
    required this.categoryID,
    required this.categoryName,
  });
  final String cityID;
  final String cityName;
  final String categoryID;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController(cityID, categoryID));
    var locations = controller.locationsSnap;

    void updateCategoryDialog() {
      controller.categoryTextController.text = categoryName;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Category Name.'),
            content: TextField(
              controller: controller.categoryTextController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'City Name',
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
                  controller.updateCategory().then((value) {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );
    }

    void deleteCategoryDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete City.'),
            content: Text(
              'Are you sure you want to delete $cityName? \n this action can not be reverted',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteCategory().then((value) {
                    if (context.mounted) Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'City: $cityName.',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Category: $categoryName.',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: updateCategoryDialog,
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: deleteCategoryDialog,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Locations.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(24), child: Divider()),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 240,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (controller.locationsList.isEmpty) {
                    return const SizedBox(
                      height: 240,
                      child: Center(
                        child: Text('No data found...'),
                      ),
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
                                constraints:
                                    const BoxConstraints(minWidth: 240),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(
                                      LocationDetailView(
                                        cityID: cityID,
                                        cityName: cityName,
                                        categoryID: categoryID,
                                        categoryName: categoryName,
                                        locationIndex: index,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    '${locations[index].get('name')} >',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
                const Padding(padding: EdgeInsets.all(24), child: Divider()),
                ElevatedButton(
                  onPressed: () => Get.to(
                    LocationAddView(
                        cityName: cityName, categoryName: categoryName),
                  ),
                  child: const Text('+ Add Location'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Get.back(),
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
