// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCkY9h3fsTuyVK4MQt02sOeZ2V6THCSaKk',
    appId: '1:552346426399:web:9e56a883ee22a36bc3092a',
    messagingSenderId: '552346426399',
    projectId: 'supereal',
    authDomain: 'supereal.firebaseapp.com',
    storageBucket: 'supereal.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBysoew2cyPyqOC1HM87v6zJ3SrcMP4A8g',
    appId: '1:552346426399:android:b81ec3389a9682acc3092a',
    messagingSenderId: '552346426399',
    projectId: 'supereal',
    storageBucket: 'supereal.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBE_g_gL-EGPsKoBs2cDz93Xf5BikH67No',
    appId: '1:552346426399:ios:f74db515bc881066c3092a',
    messagingSenderId: '552346426399',
    projectId: 'supereal',
    storageBucket: 'supereal.appspot.com',
    iosClientId: '552346426399-50hjqvnbj5mjhs5313falm6mcj2shbj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.edirnebenim',
  );
}
