import 'package:citiguide_admin/utils/constants.dart';
import 'package:citiguide_admin/views/city_view.dart';

import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryController extends GetxController {
  CategoryController(this.cityName);
  final String cityName;

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
          .doc(cityName)
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
      await firestore
          .collection('cities')
          .doc(cityName)
          .update({'name': cityTextController});

      log('City updated successfully.');
      Get.snackbar('Success', 'City updated successfully');
      cityTextController.clear();
      fetchCategories();
      Get.to(const CityView());
    } catch (e) {
      log('Error updating city: $e');
      Get.snackbar('Error', 'Failed to update city');
    }
  }

  Future<void> deleteCity() async {
    try {
      await firestore.collection('cities').doc(cityName).delete();

      log('City deleted successfully.');
      Get.snackbar('Success', 'City deleted successfully');
      fetchCategories();
    } catch (e) {
      log('Error deleting cities: $e');
      Get.snackbar('Error', 'Failed to delete city');
    }
  }

  Future<void> addCategory() async {
    try {
      DocumentReference ref = firestore
          .collection('cities')
          .doc(cityName)
          .collection('categories')
          .doc(categoryTextController.text.trim());

      DocumentSnapshot doc = await ref.get();

      if (doc.exists) {
        Get.snackbar('Error', 'Category already exists.');
      } else if (categoryTextController.text.trim().isEmpty) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.set({'name': categoryTextController.text.trim()});
        Get.snackbar('Success', 'Category created successfully.');
        categoryTextController.clear();
        fetchCategories();
      }
    } catch (e) {
      log('Error creating category: $e');
      Get.snackbar('Error', 'Failed to create category');
    }
  }
}
