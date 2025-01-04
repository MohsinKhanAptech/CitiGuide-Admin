import 'package:citiguide_admin/controllers/city_controller.dart';
import 'package:citiguide_admin/views/category_view.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CityView extends StatelessWidget {
  const CityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());
    var cities = controller.citiesSnap;

    void addCityDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add City.'),
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
                  controller.addCity().then((value) {
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
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cities.',
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
                    if (controller.citiesList.isEmpty) {
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
                          itemCount: cities.length,
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
                                        CategoryView(
                                          cityID: cities[index].id,
                                          cityName: cities[index].get('name'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      '${cities[index].get('name')} >',
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
                  onPressed: addCityDialog,
                  child: const Text('+ Add City'),
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
