import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  final TextEditingController locationController = TextEditingController();
  var locationsSnap = <DocumentSnapshot>[].obs;

  var isLoading = false.obs;
  var locationsList = <Map<String, dynamic>>[].obs;

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
      print(e.toString());
    }
  }

//This function can add category to your collection
  Future<void> addlocation() async {
    try {
      DocumentReference locationRef =
          firestore.collection('locations').doc(locationController.text.trim());

      DocumentSnapshot locationDoc = await locationRef.get();
      if (!locationDoc.exists) {
        // Create category document if it doesn't exist
        await locationRef.set({'name': locationController.text.trim()});
        Get.snackbar("Success", "location created successfully.");
        locationController.clear();
      } else {
        log("location already exists.");
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
