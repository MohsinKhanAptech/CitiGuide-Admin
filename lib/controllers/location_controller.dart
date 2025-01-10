import 'package:citiguide_admin/controllers/category_controller.dart';
import 'package:citiguide_admin/utils/constants.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationController extends GetxController {
  LocationController(this.cityID, this.categoryID);
  final String cityID;
  final String categoryID;

  var isLoading = false.obs;

  late CategoryController categoryController;

  var locationsList = <Map<String, dynamic>>[].obs;
  var locationsSnap = <DocumentSnapshot>[].obs;

  final TextEditingController categoryTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
    categoryController = Get.put(CategoryController(cityID));
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
      categoryController.fetchCategories();
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
      categoryController.fetchCategories();
      log('Category deleted successfully.');
      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      log('Error deleting category: $e');
      Get.snackbar('Error', 'Failed to delete category');
    }
  }

  var imageFile = Rxn<File>();
  var selectedFile = Rxn<File>();
  var selectedFileBytes = Rxn<List<int>>();
  var selectedFileName = ''.obs;

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        selectedFileName.value = result.files.single.name;

        if (kIsWeb) {
          selectedFileBytes.value = result.files.single.bytes;
        } else {
          selectedFile.value = File(result.files.single.path!);
        }

        Get.snackbar('Success', 'Image selected: ${selectedFileName.value}');
      } else {
        Get.snackbar('Error', 'No image selected');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
      print(e.toString());
    }
  }

  Future<String?> uploadToCloudinary() async {
    const String cloudName = 'dxbudpkpl';
    const String uploadPreset = 'locationImages';

    if (selectedFile.value == null && selectedFileBytes.value == null) {
      Get.snackbar('Error', 'Please select an image first');
    } else {
      final url =
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      try {
        final request = http.MultipartRequest('POST', url);
        request.fields['upload_preset'] = uploadPreset;

        if (kIsWeb && selectedFileBytes.value != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'file',
              selectedFileBytes.value!,
              filename: selectedFileName.value,
            ),
          );
        } else if (selectedFile.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath('file', selectedFile.value!.path),
          );
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (response.statusCode == 200) {
          final imageUrl = jsonResponse['secure_url'];
          Get.snackbar('Success', 'Image uploaded');
          return imageUrl;
        } else {
          Get.snackbar('Error', 'Upload failed: ${response.statusCode}');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to upload image: $e');
      }
    }
    return null;
  }

  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController locationDescriptionController =
      TextEditingController();
  final TextEditingController locationAddressController =
      TextEditingController();
  final TextEditingController locationLatitudeController =
      TextEditingController();
  final TextEditingController locationLongitudeController =
      TextEditingController();

  Future<void> addLocation() async {
    try {
      String? locationName = locationNameController.text.toLowerCase().trim();
      String? locationDescription = locationDescriptionController.text.trim();
      String? locationAddress = locationAddressController.text.trim();
      double? locationLatitude =
          double.tryParse(locationLatitudeController.text);
      double? locationLongitude =
          double.tryParse(locationLongitudeController.text);

      final String? imageUrl = await uploadToCloudinary();

      QuerySnapshot snap = await firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .get();

      bool exists() {
        bool exists = false;
        for (var doc in snap.docs) {
          if (doc.get('name') == locationName) exists = true;
        }
        return exists;
      }

      if (exists()) {
        Get.snackbar('Error', 'Location already exists.');
      } else if (locationName.isEmpty ||
          locationDescription.isEmpty ||
          locationAddress.isEmpty ||
          imageUrl == null ||
          locationLatitude == null ||
          locationLongitude == null) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await firestore
            .collection('cities')
            .doc(cityID)
            .collection('categories')
            .doc(categoryID)
            .collection('locations')
            .add({
          'imageUrl': imageUrl,
          'name': locationName,
          'description': locationDescription,
          'address': locationAddress,
          'geopoint': GeoPoint(locationLatitude, locationLongitude),
          'rating': 0,
        });

        Get.back(closeOverlays: true);
        Get.snackbar('Success', 'Location created successfully.');
        fetchLocations();

        locationNameController.clear();
        locationDescriptionController.clear();
        locationAddressController.clear();
        locationLatitudeController.clear();
        locationLongitudeController.clear();

        imageFile = Rxn<File>();
        selectedFile = Rxn<File>();
        selectedFileBytes = Rxn<List<int>>();
        selectedFileName = ''.obs;
      }
    } catch (e) {
      log('Error creating location: $e');
      Get.snackbar('Error', 'Failed to create location');
    }
  }

  Future<void> updateLocation(String locationID) async {
    try {
      String? locationName = locationNameController.text.toLowerCase().trim();
      String? locationDescription = locationDescriptionController.text.trim();
      String? locationAddress = locationAddressController.text.trim();
      double? locationLatitude =
          double.tryParse(locationLatitudeController.text);
      double? locationLongitude =
          double.tryParse(locationLongitudeController.text);

      final String? imageUrl = await uploadToCloudinary();

      DocumentReference ref = firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .doc(locationID);

      if (locationName.isEmpty ||
          locationDescription.isEmpty ||
          locationAddress.isEmpty ||
          imageUrl == null ||
          locationLatitude == null ||
          locationLongitude == null) {
        Get.snackbar('Error', 'Please enter valid data.');
      } else {
        await ref.update({
          'imageUrl': imageUrl,
          'name': locationName,
          'description': locationDescription,
          'address': locationAddress,
          'geopoint': GeoPoint(locationLatitude, locationLongitude),
          'rating': 0,
        });

        Get.back(closeOverlays: true);
        Get.snackbar('Success', 'Location created successfully.');
        fetchLocations();

        locationNameController.clear();
        locationDescriptionController.clear();
        locationAddressController.clear();
        locationLatitudeController.clear();
        locationLongitudeController.clear();

        imageFile = Rxn<File>();
        selectedFile = Rxn<File>();
        selectedFileBytes = Rxn<List<int>>();
        selectedFileName = ''.obs;
      }
    } catch (e) {
      log('Error creating location: $e');
      Get.snackbar('Error', 'Failed to create location');
    }
  }

  Future<void> deleteLocation(String locationID) async {
    try {
      await firestore
          .collection('cities')
          .doc(cityID)
          .collection('categories')
          .doc(categoryID)
          .collection('locations')
          .doc(locationID)
          .delete();

      Get.back(closeOverlays: true);
      fetchLocations();
      log('Location deleted successfully.');
      Get.snackbar('Success', 'Location deleted successfully');
    } catch (e) {
      log('Error deleting location: $e');
      Get.snackbar('Error', 'Failed to delete location');
    }
  }

  @override
  void dispose() {
    super.dispose();
    categoryTextController.dispose();
    locationNameController.dispose();
    locationDescriptionController.dispose();
    locationAddressController.dispose();
    locationLatitudeController.dispose();
    locationLongitudeController.dispose();
  }
}
