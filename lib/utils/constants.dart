import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final connectionChecker = InternetConnectionChecker.instance;
late SharedPreferences sharedPreferences;
var currentTheme = ThemeMode.system.obs;

Future<void> initConstants() async {
  sharedPreferences = await SharedPreferences.getInstance();
  await getTheme();
}

Future<void> getTheme() async {
  String? theme = sharedPreferences.getString('theme');

  if (theme == 'light') {
    currentTheme.value = ThemeMode.light;
  } else if (theme == 'dark') {
    currentTheme.value = ThemeMode.dark;
  } else {
    currentTheme.value = ThemeMode.system;
  }
}

Future<void> changeTheme() async {
  if (currentTheme.value == ThemeMode.light) {
    currentTheme.value = ThemeMode.dark;
    sharedPreferences.setString('theme', 'dark');
  } else {
    currentTheme.value = ThemeMode.light;
    sharedPreferences.setString('theme', 'light');
  }
}
