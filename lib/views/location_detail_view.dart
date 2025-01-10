import 'package:citiguide_admin/controllers/location_controller.dart';
import 'package:citiguide_admin/views/location_edit_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationDetailView extends StatelessWidget {
  const LocationDetailView({
    super.key,
    required this.cityID,
    required this.cityName,
    required this.categoryID,
    required this.categoryName,
    required this.locationIndex,
  });
  final String cityID;
  final String cityName;
  final String categoryID;
  final String categoryName;
  final int locationIndex;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController(cityID, categoryID));
    var locations = controller.locationsSnap;

    final String locationID = locations[locationIndex].id;

    void deleteLocationDialog() {
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
                  controller.deleteLocation(locationID).then((value) {
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
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 240,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final String locationImageUrl =
                      locations[locationIndex].get('imageUrl');
                  final String locationName =
                      locations[locationIndex].get('name');
                  final String locationDescription =
                      locations[locationIndex].get('description');
                  final String locationAddress =
                      locations[locationIndex].get('address');
                  final GeoPoint locationGeoPoint =
                      locations[locationIndex].get('geopoint');

                  return Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 500),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(locationImageUrl),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(height: 12),
                              ListTile(title: Text('Name:')),
                              LocationText(locationName),
                              SizedBox(height: 12),
                              ListTile(title: Text('Description:')),
                              LocationText(locationDescription),
                              SizedBox(height: 12),
                              ListTile(title: Text('Address:')),
                              LocationText(locationAddress),
                              SizedBox(height: 12),
                              ListTile(title: Text('Latitude, Longitude:')),
                              LocationText(
                                '${locationGeoPoint.latitude}, ${locationGeoPoint.longitude}',
                              ),
                              SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: LocaitonMap(locationGeoPoint: locationGeoPoint),
                      ),
                    ],
                  );
                }),
                const Padding(padding: EdgeInsets.all(24), child: Divider()),
                Obx(() {
                  if (!controller.isLoading.value) {
                    return ElevatedButton(
                      onPressed: () => Get.to(
                        LocationEditView(
                          cityName: cityName,
                          categoryName: categoryName,
                          locationIndex: locationIndex,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 4),
                          const Text('Edit Location'),
                        ],
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {},
                    child: Text('Loading...'),
                  );
                }),
                const SizedBox(height: 12),
                Obx(() {
                  if (!controller.isLoading.value) {
                    return ElevatedButton(
                      onPressed: deleteLocationDialog,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 4),
                          const Text('Delete Location'),
                        ],
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {},
                    child: Text('Loading...'),
                  );
                }),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: Get.back,
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

class LocationText extends StatelessWidget {
  const LocationText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(text),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}

class LocaitonMap extends StatelessWidget {
  const LocaitonMap({super.key, required this.locationGeoPoint});
  final GeoPoint locationGeoPoint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: SizedBox(
        height: 250,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              locationGeoPoint.latitude,
              locationGeoPoint.longitude,
            ),
            initialZoom: 18,
            minZoom: 16,
            maxZoom: 20,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              tileProvider: CancellableNetworkTileProvider(),
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    locationGeoPoint.latitude,
                    locationGeoPoint.longitude,
                  ),
                  rotate: true,
                  alignment: Alignment(0, -1),
                  child: Icon(
                    Icons.location_on,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
