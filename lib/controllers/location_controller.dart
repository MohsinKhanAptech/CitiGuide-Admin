import 'package:citiguide_admin/views/category_view.dart';
import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  LocationController(this.cityName, this.categoryName);
  final String cityName;
  final String categoryName;

  var isLoading = false.obs;

  var locationsList = <Map<String, dynamic>>[].obs;
  var locationsSnap = <DocumentSnapshot>[].obs;

  final TextEditingController categoryTextController = TextEditingController();
  final TextEditingController locationTextController = TextEditingController();

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
          .doc(cityName)
          .collection('categories')
          .doc(categoryName)
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
      await firestore
          .collection('cities')
          .doc(cityName)
          .collection('categories')
          .doc(categoryName)
          .update({'name': categoryTextController});

      log('City updated successfully.');
      Get.snackbar('Success', 'City updated successfully');
      categoryTextController.clear();
      fetchLocations();
      Get.to(CategoryView(cityName: cityName));
    } catch (e) {
      log('Error updating : $e');
      Get.snackbar('Error', 'Failed to update city');
    }
  }

  Future<void> deleteCategory() async {
    try {
      await firestore
          .collection('cities')
          .doc(cityName)
          .collection('categories')
          .doc(categoryName)
          .delete();

      log('City deleted successfully.');
      Get.snackbar('Success', 'City deleted successfully');
      fetchLocations();
    } catch (e) {
      log('Error deleting cities: $e');
      Get.snackbar('Error', 'Failed to delete city');
    }
  }

  Future<void> addLocation() async {
    try {
      DocumentReference ref = firestore
          .collection('cities')
          .doc(cityName)
          .collection('categories')
          .doc(categoryName)
          .collection('locations')
          .doc(locationTextController.text.trim());

      DocumentSnapshot doc = await ref.get();

      if (doc.exists) {
        Get.snackbar('Error', 'Location already exists.');
      } else if (locationTextController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.set({'name': locationTextController.text.trim()});
        Get.snackbar('Success', 'Location created successfully.');
        locationTextController.clear();
        fetchLocations();
      }
    } catch (e) {
      log('Error creating location: $e');
      Get.snackbar('Error', 'Failed to create location');
    }
  }
}
