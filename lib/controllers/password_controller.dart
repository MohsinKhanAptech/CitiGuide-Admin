import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordController extends GetxController {
  PasswordController({this.verify});
  final VoidCallback? verify;

  var isLoading = false.obs;
  static var isValid = false.obs;
  static var attempsLeft = 3;

  late String password;

  final TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPassword();
  }

  Future<void> fetchPassword() async {
    try {
      isLoading.value = true;
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('admin')
          .doc('admin')
          .get();
      password = doc.get('password');
    } catch (e) {
      log('Error, something went wrong while fetching password: $e');
      Get.snackbar('Error', 'Could not fetch password.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyPassword() async {
    try {
      var encryptedPassword = sha256.convert(
        utf8.encode(passwordController.text.trim()),
      );
      isValid.value = password == encryptedPassword.toString();

      if (isValid.value) {
        verify!();
      } else if (attempsLeft == 0) {
        SystemNavigator.pop();
      } else {
        Get.snackbar('Wrong password.', '$attempsLeft Attempts left.');
        attempsLeft--;
      }
    } catch (e) {
      log('Error, something went wrong while verifying password: $e');
      Get.snackbar('Error', 'Could not verify password.');
    }
    passwordController.clear();
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      String oldPassword = sha256
          .convert(utf8.encode(passwordController.text.trim()))
          .toString();

      String encryptedNewPassword =
          sha256.convert(utf8.encode(newPassword)).toString();

      if (password != oldPassword) {
        Get.snackbar('Wrong Password.', 'Please enter the correct password.');
      } else if (password == encryptedNewPassword) {
        Get.snackbar(
          'Matching Password.',
          'Your old and new passwords are the same,\n please enter a different password.',
        );
      } else {
        isLoading.value = true;

        await FirebaseFirestore.instance
            .collection('admin')
            .doc('admin')
            .update({'password': encryptedNewPassword});

        Get.back();
        Get.snackbar('Success', 'Password updated.');
      }
    } catch (e) {
      log('Error, something went wrong while updating password: $e');
      Get.snackbar('Error', 'Could not update password.');
    }
    passwordController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
  }
}
