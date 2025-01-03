import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CityController extends GetxController {
  var isLoading = false.obs;

  var citiesList = <Map<String, dynamic>>[].obs;
  var citiesSnap = <DocumentSnapshot>[].obs;

  final TextEditingController cityTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snap =
          await FirebaseFirestore.instance.collection('cities').get();

      if (snap.docs.isNotEmpty) {
        List<Map<String, dynamic>> list = [];
        for (var doc in snap.docs) {
          list.add(doc.data() as Map<String, dynamic>);
        }
        citiesList.value = list;
        citiesSnap.value = snap.docs;
      }
    } catch (e) {
      log('Error fetching cities data: $e');
      Get.snackbar('Error', 'Failed to fetch cities data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCity() async {
    try {
      DocumentReference ref =
          firestore.collection('cities').doc(cityTextController.text.trim());

      DocumentSnapshot doc = await ref.get();

      if (doc.exists) {
        Get.snackbar('Error', 'City already exists.');
      } else if (cityTextController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.set({'name': cityTextController.text.trim()});
        Get.snackbar('Success', 'City created successfully.');
        cityTextController.clear();
        fetchCities();
      }
    } catch (e) {
      log('Error creating city: $e');
      Get.snackbar('Error', 'Failed to create city');
    }
  }
}
