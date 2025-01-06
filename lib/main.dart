import 'package:citiguide_admin/utils/constants.dart';
import 'package:citiguide_admin/views/city_view.dart';
import 'package:citiguide_admin/views/internet_unavaliable_view.dart';
import 'package:citiguide_admin/views/password_view.dart';
import 'package:citiguide_admin/views/update_password_view.dart';

import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide_admin/firebase_options.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
        home: const MainView());
  }
}

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool internetAvailable = true;
  Timer? waitForReconnect;
  late StreamSubscription<InternetConnectionStatus> subscription;

  bool verified = false;

  @override
  void initState() {
    super.initState();

    subscription = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        if (status == InternetConnectionStatus.connected) {
          setState(() => internetAvailable = true);
          waitForReconnect?.cancel();
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text('internet unavailable, please reconnect.'),
                ),
                duration: Duration(milliseconds: 4500),
              ),
            );
          }
          waitForReconnect = Timer(Duration(milliseconds: 5000), () {
            setState(() => internetAvailable = false);
          });
        }
      },
    );
  }

  void verify() {
    setState(() => verified = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!internetAvailable) {
      return InternetUnavailableView();
    } else if (!verified) {
      return PasswordView(
        verify: verify,
      );
    }
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, Admin.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.to(const CityView()),
                  child: const Text('Cities >'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.to(const UpdatePasswordView()),
                  child: const Text('Change Password >'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    connectionChecker.dispose();
    super.dispose();
  }
}
