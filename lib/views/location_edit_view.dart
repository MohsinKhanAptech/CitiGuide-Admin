import 'package:citiguide_admin/controllers/location_controller.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationEditView extends StatelessWidget {
  const LocationEditView({
    super.key,
    required this.cityName,
    required this.categoryName,
    required this.locationIndex,
  });

  final String cityName;
  final String categoryName;
  final int locationIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController(cityName, categoryName));
    var locations = controller.locationsSnap;

    final String locationID = locations[locationIndex].id;

    final String locationName = locations[locationIndex].get('name');
    final String locationDescription =
        locations[locationIndex].get('description');
    final String locationAddress = locations[locationIndex].get('address');
    final GeoPoint locationGeoPoint = locations[locationIndex].get('geopoint');

    controller.locationNameController.text = locationName;
    controller.locationDescriptionController.text = locationDescription;
    controller.locationAddressController.text = locationAddress;
    controller.locationLatitudeController.text =
        locationGeoPoint.latitude.toString();
    controller.locationLongitudeController.text =
        locationGeoPoint.longitude.toString();

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
                Text(
                  'Category: $categoryName.',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Add Location.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(24), child: Divider()),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 240,
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                        return InkWell(
                          onTap: controller.pickImage,
                          child: Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).primaryColor.withAlpha(52),
                              border: Border.all(width: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: controller.selectedFileName.isEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          //color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Location Image',
                                          style: TextStyle(
                                            //color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(controller.selectedFileName.value),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.locationNameController,
                        decoration: const InputDecoration(
                          labelText: 'Location Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.locationDescriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Location Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.locationAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Location Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.locationLatitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Location Latitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.locationLongitudeController,
                        decoration: const InputDecoration(
                          labelText: 'Location Longitude',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(24), child: Divider()),
                ElevatedButton(
                  onPressed: () => controller.updateLocation(locationID),
                  child: const Text('+ Submit'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: Get.back,
                  child: const Text('< Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
