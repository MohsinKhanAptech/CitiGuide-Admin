import 'dart:developer';

// ignore: unused_import
import 'package:citiguide_admin/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class hotelcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController hotelController = TextEditingController();
  var hotel = <DocumentSnapshot>[].obs;

  var isLoading = false.obs;
  var userdata = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchdata();
  }

  Future<void> fetchdata() async {
    try {
      isLoading.value = true;
      final QuerySnapshot data =
          await FirebaseFirestore.instance.collection("Hotels").get();

      if (data.docs.isNotEmpty) {
        List<Map<String, dynamic>> userlist = [];
        for (var doc in data.docs) {
          userlist.add(doc.data() as Map<String, dynamic>);
        }
        userdata.value = userlist;
        hotel.value = data.docs;
        isLoading.value = false;
        // print(userdata.value.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

//This function can add category to your collection
  Future<void> addlocation() async {
    try {
      DocumentReference locationRef =
          firestore.collection('Hotels').doc(hotelController.text.trim());

      DocumentSnapshot locationDoc = await locationRef.get();
      if (!locationDoc.exists) {
        // Create category document if it doesn't exist
        await locationRef.set({'hotel name': hotelController.text.trim()});
        Get.snackbar("Success", "location created successfully.");
        hotelController.clear();
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
          .collection('Hotels')
          .doc(docId)
          .update({'hotel name': newName});
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
      await firestore.collection('Hotels').doc(docId).delete();
      log("location deleted successfully.");
      fetchdata(); // Refresh the data after deletion
      Get.snackbar("Success", "location deleted successfully");
    } catch (e) {
      log("Error deleting locations: $e");
      Get.snackbar("Error", "Failed to delete location");
    }
  }
}
