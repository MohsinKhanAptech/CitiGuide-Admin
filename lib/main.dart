import 'package:citiguide_admin/views/addlocationscreen.dart';
import 'package:citiguide_admin/views/displayloction.dart';
import 'package:citiguide_admin/views/manageciti.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_admin/firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CitiGuide Admin',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        useMaterial3: true,
      ),
      // home: const MainScreen(),

      home: Scaffold(
        appBar: AppBar(
          title: Text("Admin panel"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              // Title(
              //     color: Colors.black,
              //     child: TextButton(
              //         onPressed: () {}, child: Text("Create Categories"))),
              // Title(
              //     color: Colors.black,
              //     child: TextButton(
              //         onPressed: () {}, child: Text("Display Categories"))),
              // Title(
              //     color: Colors.black,
              //     child: TextButton(
              //         onPressed: () {}, child: Text("Display Products"))),
              Title(
                  color: Colors.black,
                  child: TextButton(
                      onPressed: () {
                        Get.to(AddlocationScreen());
                      },
                      child: Text("Create Location"))),
              Title(
                  color: Colors.black,
                  child: TextButton(
                      onPressed: () {
                        Get.to(DisplaylocationScreen());
                      },
                      child: Text("display Location"))),
              Title(
                  color: Colors.black,
                  child: TextButton(
                      onPressed: () {
                        Get.to(ManagecitiScreen);
                      },
                      child: Text("display City"))),
            ],
          ),
        ),
      ),
    );
  }
}
