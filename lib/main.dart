import 'package:citiguide_admin/views/view_locations.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_admin/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CitiGuide Admin',
        theme: ThemeData(useMaterial3: true),
        home: const ViewLocations()
        // drawer: Drawer(
        //   child: ListView(
        //     children: [
        //       Title(
        //         color: Colors.black,
        //         child: TextButton(
        //           onPressed: () {
        //             Get.to(const AddlocationScreen());
        //           },
        //           child: const Text("Create Location"),
        //         ),
        //       ),
        //       Title(
        //         color: Colors.black,
        //         child: TextButton(
        //           onPressed: () {
        //             Get.to(const DisplaylocationScreen());
        //           },
        //           child: const Text("display Location"),
        //         ),
        //       ),
        //       Title(
        //         color: Colors.black,
        //         child: TextButton(
        //           onPressed: () {
        //             Get.to(ManagecitiScreen);
        //           },
        //           child: const Text("display City"),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'Welcome, Admin.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.to(const ViewLocations()),
              child: const Text('Locations >'),
            ),
          ],
        ),
      ),
    );
  }
}
