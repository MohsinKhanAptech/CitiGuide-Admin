import 'package:citiguide_admin/utils/constants.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController extends GetxController {
  CategoryController(this.cityID);
  final String cityID;

  var isLoading = false.obs;

  var categoriesList = <Map<String, dynamic>>[].obs;
  var categoriesSnap = <DocumentSnapshot>[].obs;

  final TextEditingController cityTextController = TextEditingController();
  final TextEditingController categoryTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .get();

      if (snap.docs.isNotEmpty) {
        List<Map<String, dynamic>> list = [];
        for (var doc in snap.docs) {
          list.add(doc.data() as Map<String, dynamic>);
        }
        categoriesList.value = list;
        categoriesSnap.value = snap.docs;
      }
    } catch (e) {
      log('Error fetching categories data: $e');
      Get.snackbar('Error', 'Failed to fetch categories data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCity() async {
    try {
      String cityName = cityTextController.text.trim();
      await firestore
          .collection('cities')
          .doc(cityID)
          .update({'name': cityName});

      Get.back(closeOverlays: true);
      log('City updated successfully.');
      Get.snackbar('Success', 'City updated successfully');
      cityTextController.clear();
    } catch (e) {
      log('Error updating city: $e');
      Get.snackbar('Error', 'Failed to update city');
    }
  }

  Future<void> deleteCity() async {
    try {
      await firestore.collection('cities').doc(cityID).delete();

      Get.back(closeOverlays: true);
      log('City deleted successfully.');
      Get.snackbar('Success', 'City deleted successfully');
    } catch (e) {
      log('Error deleting cities: $e');
      Get.snackbar('Error', 'Failed to delete city');
    }
  }

  Future<void> addCategory() async {
    try {
      String? categoryName = categoryTextController.text.trim();

      QuerySnapshot snap = await firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .get();

      bool exists() {
        bool exists = false;
        for (var doc in snap.docs) {
          if (doc.get('name') == categoryName) exists = true;
        }
        return exists;
      }

      if (exists()) {
        Get.snackbar('Error', 'Category already exists.');
      } else if (categoryName.isEmpty) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await firestore
            .collection('cities')
            .doc(cityID)
            .collection('categories')
            .add({'name': categoryName});

        Get.snackbar('Success', 'Category created successfully.');
        categoryTextController.clear();
        fetchCategories();
      }
    } catch (e) {
      log('Error creating category: $e');
      Get.snackbar('Error', 'Failed to create category');
    }
  }

  @override
  void dispose() {
    super.dispose();
    cityTextController.dispose();
    categoryTextController.dispose();
  }
}
