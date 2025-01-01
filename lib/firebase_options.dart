// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAtv0kRkUuROZqd9QbKXReH7Ctq3_slFSE',
    appId: '1:910378647353:web:604a54e8ad71bde9dab2e8',
    messagingSenderId: '910378647353',
    projectId: 'citiguide-18df9',
    authDomain: 'citiguide-18df9.firebaseapp.com',
    storageBucket: 'citiguide-18df9.firebasestorage.app',
    measurementId: 'G-D5DZ599LJY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBy0EXh1lfVRqSb7ududAwIR0Jq7F8EJvI',
    appId: '1:910378647353:android:3c2b8e88795193b2dab2e8',
    messagingSenderId: '910378647353',
    projectId: 'citiguide-18df9',
    storageBucket: 'citiguide-18df9.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbdDRfYW01xulZClT6pUEgqPyDnufo86U',
    appId: '1:910378647353:ios:26802ceb10bfc841dab2e8',
    messagingSenderId: '910378647353',
    projectId: 'citiguide-18df9',
    storageBucket: 'citiguide-18df9.firebasestorage.app',
    iosBundleId: 'com.example.citiguideAdmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbdDRfYW01xulZClT6pUEgqPyDnufo86U',
    appId: '1:910378647353:ios:26802ceb10bfc841dab2e8',
    messagingSenderId: '910378647353',
    projectId: 'citiguide-18df9',
    storageBucket: 'citiguide-18df9.firebasestorage.app',
    iosBundleId: 'com.example.citiguideAdmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAtv0kRkUuROZqd9QbKXReH7Ctq3_slFSE',
    appId: '1:910378647353:web:604a54e8ad71bde9dab2e8',
    messagingSenderId: '910378647353',
    projectId: 'citiguide-18df9',
    authDomain: 'citiguide-18df9.firebaseapp.com',
    storageBucket: 'citiguide-18df9.firebasestorage.app',
    measurementId: 'G-D5DZ599LJY',
  );
}
