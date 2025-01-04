import 'package:citiguide_admin/controllers/category_controller.dart';
import 'package:citiguide_admin/views/location_view.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.cityID, required this.cityName});
  final String cityID;
  final String cityName;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController(cityID));
    var categories = controller.categoriesSnap;

    void updateCityDialogue() {
      controller.cityTextController.text = cityName;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update City Name.'),
            content: TextField(
              controller: controller.cityTextController,
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
                  controller.updateCity().then((value) {
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

    void deleteCityDialogue() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete City.'),
            content: Text(
              'Are you sure you want to delete $cityName?\n this action can not be reverted',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  controller.deleteCity().then((value) {
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

    void addCategoryDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Category.'),
            content: TextField(
              controller: controller.categoryTextController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Category Name',
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
                  controller.addCategory().then((value) {
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

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'City: $cityName.',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: updateCityDialogue,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: deleteCityDialogue,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Categories.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.all(24), child: Divider()),
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const SizedBox(
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (controller.categoriesList.isEmpty) {
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
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 240),
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(
                                    LocationView(
                                      cityName: cityName,
                                      cityID: cityID,
                                      categoryID: categories[index].id,
                                      categoryName:
                                          categories[index].get('name'),
                                    ),
                                  );
                                },
                                child: Text(
                                  '${categories[index].get('name')} >',
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
              onPressed: addCategoryDialog,
              child: const Text('+ Add Category'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('< Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
