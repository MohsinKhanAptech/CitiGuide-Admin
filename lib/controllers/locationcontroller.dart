import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  var isLoading = false.obs;
  var locationsList = <Map<String, dynamic>>[].obs;
  var locationsSnap = <DocumentSnapshot>[].obs;

  final TextEditingController locationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      isLoading.value = true;
      final QuerySnapshot data =
          await FirebaseFirestore.instance.collection("locations").get();

      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> locations = [];
        for (var doc in data.docs) {
          locations.add(doc.data() as Map<String, dynamic>);
        }
        locationsList.value = locations;
        locationsSnap.value = data.docs;
        isLoading.value = false;
      }
    } catch (e) {
      log("Error fetching location data: $e");
      Get.snackbar("Error", "Failed to fetch location data.");
    }
  }

  Future<void> addLocation() async {
    try {
      DocumentReference locationRef =
          firestore.collection('locations').doc(locationController.text.trim());

      DocumentSnapshot locationDoc = await locationRef.get();

      if (!locationDoc.exists) {
        await locationRef.set({'name': locationController.text.trim()});
        Get.snackbar("Success", "location created successfully.");
        locationController.clear();
        fetchdata();
      } else {
        Get.snackbar("Error", "Location already exists.");
      }
    } catch (e) {
      log("Error creating location: $e");
      Get.snackbar("Error", "Failed to create location");
    }
  }

  Future<void> updateCategory(String docId, String newName) async {
    try {
      await firestore
          .collection('locations')
          .doc(docId)
          .update({'name': newName});
      log("location updated successfully.");
      fetchdata(); // Refresh the data after the update
      Get.snackbar("Success", "location updated successfully");
    } catch (e) {
      log("Error updating category: $e");
      Get.snackbar("Error", "Failed to update location");
    }
  }

  Future<void> deleteCategory(String docId) async {
    try {
      await firestore.collection('locations').doc(docId).delete();
      log("location deleted successfully.");
      fetchdata(); // Refresh the data after deletion
      Get.snackbar("Success", "location deleted successfully");
    } catch (e) {
      log("Error deleting locations: $e");
      Get.snackbar("Error", "Failed to delete location");
    }
  }
}
