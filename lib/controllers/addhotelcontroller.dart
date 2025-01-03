import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// ignore: unused_import
import 'package:citiguide_admin/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: camel_case_types
class hotelcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController hotelnameController = TextEditingController();
  final TextEditingController hoteladdressController = TextEditingController();
  final TextEditingController hotelDescriptionController =
      TextEditingController();
  final TextEditingController hotelLongitudeController =
      TextEditingController();
  final TextEditingController hotelLatitudeController = TextEditingController();
  final TextEditingController hotelratingController = TextEditingController();
  var hotel = <DocumentSnapshot>[].obs;

  var isLoading = false.obs;
  var userdata = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchdata();
  }

  var imageFile = Rxn<File>();

  /// Pick an image from the gallery
  var selectedFile = Rxn<File>(); // To store the selected file
  var selectedFileBytes = Rxn<List<int>>(); // For file preview in web
  var selectedFileName = ''.obs;

  /// Pick an image using FilePicker
  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        selectedFileName.value = result.files.single.name;

        if (kIsWeb) {
          // For web, save the file bytes
          selectedFileBytes.value = result.files.single.bytes;
        } else {
          // For mobile/desktop, save the file
          selectedFile.value = File(result.files.single.path!);
        }

        Get.snackbar("Success", "Image selected: ${selectedFileName.value}");
      } else {
        Get.snackbar("Error", "No image selected");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
      log(e.toString());
    }
  }

  /// Upload the selected image to Cloudinary and return the URL
  Future<String?> uploadToCloudinary() async {
    const String cloudName =
        'dw3ueziv5'; // Replace with your Cloudinary cloud name
    const String uploadPreset =
        'images'; // Replace with your Cloudinary upload preset

    if (selectedFile.value == null && selectedFileBytes.value == null) {
      Get.snackbar("Error", "Please select an image first");
      return null;
    }

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      if (kIsWeb && selectedFileBytes.value != null) {
        // For web, use the bytes
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            selectedFileBytes.value!,
            filename: selectedFileName.value,
          ),
        );
      } else if (selectedFile.value != null) {
        // For mobile/desktop, use the file path
        request.files.add(
          await http.MultipartFile.fromPath('file', selectedFile.value!.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200) {
        final imageUrl = jsonResponse['secure_url'];
        Get.snackbar("Success", "Image uploaded: $imageUrl");
        return imageUrl;
      } else {
        Get.snackbar("Error", "Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image: $e");
    }
    return null;
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
          firestore.collection('Hotels').doc(hotelnameController.text.trim());

      DocumentSnapshot locationDoc = await locationRef.get();
      if (!locationDoc.exists) {
        // Create category document if it doesn't exist
        await locationRef.set({'hotel name': hotelnameController.text.trim()});
        Get.snackbar("Success", "location created successfully.");
        hotelnameController.clear();
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
