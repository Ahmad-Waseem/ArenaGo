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
    apiKey: 'AIzaSyDidZVCm1mqJE3Zbiy7gakxkWEmWbAskYA',
    appId: '1:965928589812:web:d8b7fc2e6865ac10adc1a1',
    messagingSenderId: '965928589812',
    projectId: 'arenago-56abc',
    authDomain: 'arenago-56abc.firebaseapp.com',
    databaseURL: 'https://arenago-56abc-default-rtdb.firebaseio.com',
    storageBucket: 'arenago-56abc.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9zQalUWmrTksN0mOEW5IhtSuiel6QCEM',
    appId: '1:965928589812:android:34e72f25b42ee9e3adc1a1',
    messagingSenderId: '965928589812',
    projectId: 'arenago-56abc',
    databaseURL: 'https://arenago-56abc-default-rtdb.firebaseio.com',
    storageBucket: 'arenago-56abc.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDedZaw4AjhWcHz3pbojUnO2EBwMIgPbj0',
    appId: '1:965928589812:ios:277a723dd71fedb6adc1a1',
    messagingSenderId: '965928589812',
    projectId: 'arenago-56abc',
    databaseURL: 'https://arenago-56abc-default-rtdb.firebaseio.com',
    storageBucket: 'arenago-56abc.appspot.com',
    iosBundleId: 'com.example.arenago',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDedZaw4AjhWcHz3pbojUnO2EBwMIgPbj0',
    appId: '1:965928589812:ios:277a723dd71fedb6adc1a1',
    messagingSenderId: '965928589812',
    projectId: 'arenago-56abc',
    databaseURL: 'https://arenago-56abc-default-rtdb.firebaseio.com',
    storageBucket: 'arenago-56abc.appspot.com',
    iosBundleId: 'com.example.arenago',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDidZVCm1mqJE3Zbiy7gakxkWEmWbAskYA',
    appId: '1:965928589812:web:9489f53175a7b67dadc1a1',
    messagingSenderId: '965928589812',
    projectId: 'arenago-56abc',
    authDomain: 'arenago-56abc.firebaseapp.com',
    databaseURL: 'https://arenago-56abc-default-rtdb.firebaseio.com',
    storageBucket: 'arenago-56abc.appspot.com',
  );
}