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
    apiKey: 'AIzaSyCaeXsat5rSX388AwSu0vaOeAMhRWhCFHY',
    appId: '1:716277686315:web:519e2148f0c7ea37f4ca6e',
    messagingSenderId: '716277686315',
    projectId: 'revrentals-d1cb4',
    authDomain: 'revrentals-d1cb4.firebaseapp.com',
    storageBucket: 'revrentals-d1cb4.appspot.com',
    measurementId: 'G-1YLW73XL8V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAcoOOllcMNOLIC1jn8LBaF6QfDwHnLcmE',
    appId: '1:716277686315:android:bc411130cdd31586f4ca6e',
    messagingSenderId: '716277686315',
    projectId: 'revrentals-d1cb4',
    storageBucket: 'revrentals-d1cb4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBgs8RBl6b6654do1e9Pi480lvtXyCzoOk',
    appId: '1:716277686315:ios:ab30b43548fcf395f4ca6e',
    messagingSenderId: '716277686315',
    projectId: 'revrentals-d1cb4',
    storageBucket: 'revrentals-d1cb4.appspot.com',
    iosBundleId: 'com.example.revrentals',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBgs8RBl6b6654do1e9Pi480lvtXyCzoOk',
    appId: '1:716277686315:ios:ab30b43548fcf395f4ca6e',
    messagingSenderId: '716277686315',
    projectId: 'revrentals-d1cb4',
    storageBucket: 'revrentals-d1cb4.appspot.com',
    iosBundleId: 'com.example.revrentals',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCaeXsat5rSX388AwSu0vaOeAMhRWhCFHY',
    appId: '1:716277686315:web:06416ce1aefdac27f4ca6e',
    messagingSenderId: '716277686315',
    projectId: 'revrentals-d1cb4',
    authDomain: 'revrentals-d1cb4.firebaseapp.com',
    storageBucket: 'revrentals-d1cb4.appspot.com',
    measurementId: 'G-YW8QVYC9XB',
  );
}
