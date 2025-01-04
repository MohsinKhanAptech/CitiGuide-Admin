import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  LocationController(this.cityID, this.categoryID);
  final String cityID;
  final String categoryID;

  var isLoading = false.obs;

  var locationsList = <Map<String, dynamic>>[].obs;
  var locationsSnap = <DocumentSnapshot>[].obs;

  final TextEditingController categoryTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .get();

      if (snap.docs.isNotEmpty) {
        List<Map<String, dynamic>> list = [];
        for (var doc in snap.docs) {
          list.add(doc.data() as Map<String, dynamic>);
        }
        locationsList.value = list;
        locationsSnap.value = snap.docs;
      }
    } catch (e) {
      log('Error fetching locations data: $e');
      Get.snackbar('Error', 'Failed to fetch locations data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCategory() async {
    try {
      String? categoryName = categoryTextController.text.trim();

      await firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .update({'name': categoryName});

      Get.back(closeOverlays: true);
      log('Category updated successfully.');
      Get.snackbar('Success', 'Category updated successfully');
      categoryTextController.clear();
    } catch (e) {
      log('Error updating category: $e');
      Get.snackbar('Error', 'Failed to update category');
    }
  }

  Future<void> deleteCategory() async {
    try {
      await firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .delete();

      Get.back(closeOverlays: true);
      log('Category deleted successfully.');
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      log('Error deleting cities: $e');
      Get.snackbar('Error', 'Failed to delete city');
    }
  }

  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController locationDescriptionController =
      TextEditingController();
  final TextEditingController locationLatitudeController =
      TextEditingController();
  final TextEditingController locationLongitudeController =
      TextEditingController();

  Future<void> addLocation() async {
    try {
      String? locationName = locationNameController.text.trim();
      String? locationDescription = locationDescriptionController.text.trim();
      double? locationLatitude =
          double.tryParse(locationLatitudeController.text);
      double? locationLongitude =
          double.tryParse(locationLongitudeController.text);

      DocumentReference ref = firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .doc(locationNameController.text.trim());

      DocumentSnapshot doc = await ref.get();

      if (doc.exists) {
        Get.snackbar('Error', 'Location already exists.');
      } else if (locationName.isEmpty ||
          locationDescription.isEmpty ||
          locationLatitude != null ||
          locationLongitude != null) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.set({
          'name': locationName,
          'description': locationDescription,
          'geopiont': [locationLatitude, locationLongitude],
          'rating': 0,
        });

        Get.back(closeOverlays: true);
        Get.snackbar('Success', 'Location created successfully.');

        locationNameController.clear();
        locationDescriptionController.clear();
        locationLatitudeController.clear();
        locationLongitudeController.clear();
      }
    } catch (e) {
      log('Error creating location: $e');
      Get.snackbar('Error', 'Failed to create location');
    }
  }

  Future<void> updateLocation() async {
    try {
      String? locationName = locationNameController.text.trim();
      String? locationDescription = locationDescriptionController.text.trim();
      double? locationLatitude =
          double.tryParse(locationLatitudeController.text);
      double? locationLongitude =
          double.tryParse(locationLongitudeController.text);

      DocumentReference ref = firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .doc(locationNameController.text.trim());

      if (locationName.isEmpty ||
          locationDescription.isEmpty ||
          locationLatitude != null ||
          locationLongitude != null) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.update({
          'name': locationName,
          'description': locationDescription,
          'geopiont': [locationLatitude, locationLongitude],
          'rating': 0,
        });

        Get.back(closeOverlays: true);
        Get.snackbar('Success', 'Location created successfully.');

        locationNameController.clear();
        locationDescriptionController.clear();
        locationLatitudeController.clear();
        locationLongitudeController.clear();
      }
    } catch (e) {
      log('Error creating location: $e');
      Get.snackbar('Error', 'Failed to create location');
    }
  }

  @override
  void dispose() {
    super.dispose();
    categoryTextController.dispose();
    locationNameController.dispose();
    locationDescriptionController.dispose();
    locationLatitudeController.dispose();
    locationLongitudeController.dispose();
  }
}
