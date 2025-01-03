import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class Resturantcontroller extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController RestaurantNameController = TextEditingController();
  final TextEditingController RestaurantDescriptionController = TextEditingController();
    final TextEditingController RestaurantAddressController = TextEditingController();
     final TextEditingController RestauranLongitudeController = TextEditingController();
      final TextEditingController RestaurantLatitudeController = TextEditingController();
       final TextEditingController RestaurantRatingController = TextEditingController();
  var categories = <DocumentSnapshot>[].obs;
  var products = <DocumentSnapshot>[].obs;

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
        'dunyj3gte'; // Replace with your Cloudinary cloud name
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

  Future<void> addProduct(String catname) async {
    double? price = double.tryParse(RestaurantDescriptionController.text);
    final imageUrl = await uploadToCloudinary();

    if (imageUrl == null) {
      Get.snackbar("Error", "Image not found");
    }

    if (catname.isEmpty ||
        RestaurantNameController.text.trim().isEmpty ||
        price == null) {
      Get.snackbar(
          "Error", "Please provide valid product and category details");
      return;
    }

    try {
      // await addCategoryIfNotExists(categoryName);
      CollectionReference productsCollection = firestore
          .collection('Restaurants')
          .doc(catname)
          .collection('products');
      await productsCollection.add({
        'name': RestaurantNameController.text.trim(),
        'price': price,
        'imageUrl': imageUrl,
      });
      Get.snackbar("Success", "Product added to category successfully");
      Get.to(());
    } catch (e) {
      log("Error adding product: $e");
      Get.snackbar("Error", "Failed to add product");
    }
  }

// Fetch products for a specific category
  Future<void> fetchProducts(String categoryId) async {
    try {
      final QuerySnapshot productData = await firestore
          .collection('Restaurants')
          .doc(categoryId)
          .collection('products')
          .get();

      products.value = productData.docs;
    } catch (e) {
      log("Error fetching products: $e");
      Get.snackbar("Error", "Failed to fetch products");
    }
  }

  // Update a specific product
  Future<void> updateProduct(String categoryId, String productId,
      String newName, double newPrice) async {
    try {
      await firestore
          .collection('Restaurants')
          .doc(categoryId)
          .collection('products')
          .doc(productId)
          .update({'name': newName, 'price': newPrice});
      log("Product updated successfully.");
      fetchProducts(categoryId); // Refresh products after updating
      Get.snackbar("Success", "Product updated successfully");
    } catch (e) {
      log("Error updating product: $e");
      Get.snackbar("Error", "Failed to update product");
    }
  }

  Future<void> deleteProduct(String categoryId, String productId) async {
    try {
      // Reference to the product document
      await firestore
          .collection('Restaurants')
          .doc(categoryId)
          .collection('products')
          .doc(productId)
          .delete();

      // Refresh the products list
      fetchProducts(categoryId);

      Get.snackbar("Success", "Product deleted successfully");
      log("Product deleted successfully.");
    } catch (e) {
      log("Error deleting product: $e");
      Get.snackbar("Error", "Failed to delete product");
    }
  }

// var allcategories = <Map<String, dynamic>>[].obs;

//   final isLoading = false.obs;
//   @override
//   void onInit() {
//     super.onInit();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     try {
//       isLoading.value = true;
//       categories.clear();
//       QuerySnapshot categorySnapshot =
//           await firestore.collection('categories').get();

//       for (var categoryDoc in categorySnapshot.docs) {
//         String categoryId = categoryDoc.id;
//         String categoryName = categoryDoc['name'];
//         CollectionReference productsCollection = firestore
//             .collection('categories')
//             .doc(categoryId)
//             .collection('products');
//         QuerySnapshot productsSnapshot = await productsCollection.get();
//         List<Map<String, dynamic>> products = [];
//         for (var productDoc in productsSnapshot.docs) {
//           products.add({
//             'productId': productDoc.id,
//             ...productDoc.data() as Map<String, dynamic>,
//           });
//         }
//         allcategories.add({
//           "categoryId": categoryId,
//           'categoryName': categoryName,
//           'products': products
//         });
//       }
//       isLoading.value = false;

//       log(categories.toString());
//     } catch (e) {
//       log(e.toString());
//     }
//   }
}
