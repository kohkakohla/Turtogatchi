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
    apiKey: 'AIzaSyA-QCsNLz3sUA2KYvv59MP2D2jEbWYD8TE',
    appId: '1:261300078740:web:67642b84c65bf29b070c81',
    messagingSenderId: '261300078740',
    projectId: 'turtogachi',
    authDomain: 'turtogachi.firebaseapp.com',
    storageBucket: 'turtogachi.appspot.com',
    measurementId: 'G-5JJVXK6RYJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIOHL3sywU3ZDMWUakMngeDEOdvoe97nA',
    appId: '1:261300078740:android:fa0558eb64d289d8070c81',
    messagingSenderId: '261300078740',
    projectId: 'turtogachi',
    storageBucket: 'turtogachi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA07ufVupqEQuBiWXZoFGa5Q0AUqohArpE',
    appId: '1:261300078740:ios:d070fb50f57baddf070c81',
    messagingSenderId: '261300078740',
    projectId: 'turtogachi',
    storageBucket: 'turtogachi.appspot.com',
    iosClientId: '261300078740-2pa0pmtv9dd4k5r4qaaa2ios8ab67eca.apps.googleusercontent.com',
    iosBundleId: 'com.example.turtogatchi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA07ufVupqEQuBiWXZoFGa5Q0AUqohArpE',
    appId: '1:261300078740:ios:d070fb50f57baddf070c81',
    messagingSenderId: '261300078740',
    projectId: 'turtogachi',
    storageBucket: 'turtogachi.appspot.com',
    iosClientId: '261300078740-2pa0pmtv9dd4k5r4qaaa2ios8ab67eca.apps.googleusercontent.com',
    iosBundleId: 'com.example.turtogatchi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA-QCsNLz3sUA2KYvv59MP2D2jEbWYD8TE',
    appId: '1:261300078740:web:14164ae02bee43ef070c81',
    messagingSenderId: '261300078740',
    projectId: 'turtogachi',
    authDomain: 'turtogachi.firebaseapp.com',
    storageBucket: 'turtogachi.appspot.com',
    measurementId: 'G-HX4XQJLCDR',
  );
}