// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';


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

  static  FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['APIKEY']!,
    appId: dotenv.env['APIID']!,
    messagingSenderId: dotenv.env['MESSAGINGSERVERID']!,
    projectId: 'grothon-b22cb',
    authDomain: 'grothon-b22cb.firebaseapp.com',
    storageBucket: 'grothon-b22cb.firebasestorage.app',
    measurementId: 'G-1ZM6CXFNWP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQPPSJ8T03EV74lI4B_MRTFMF7TQdN7aI',
    appId: '1:877786522652:android:01d5601d51d09ced292bd9',
    messagingSenderId: '877786522652',
    projectId: 'grothon-b22cb',
    storageBucket: 'grothon-b22cb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJu69qJ8Zf31XIdYqutd1UEiD9WVM4CZc',
    appId: '1:877786522652:ios:ffe0f5a6efecbb84292bd9',
    messagingSenderId: '877786522652',
    projectId: 'grothon-b22cb',
    storageBucket: 'grothon-b22cb.firebasestorage.app',
    iosBundleId: 'com.example.grothon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBJu69qJ8Zf31XIdYqutd1UEiD9WVM4CZc',
    appId: '1:877786522652:ios:ffe0f5a6efecbb84292bd9',
    messagingSenderId: '877786522652',
    projectId: 'grothon-b22cb',
    storageBucket: 'grothon-b22cb.firebasestorage.app',
    iosBundleId: 'com.example.grothon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBLS25tayVZ-GKBaV0aK-R2hMbaCef_XIs',
    appId: '1:877786522652:web:8cb3adebeb36720b292bd9',
    messagingSenderId: '877786522652',
    projectId: 'grothon-b22cb',
    authDomain: 'grothon-b22cb.firebaseapp.com',
    storageBucket: 'grothon-b22cb.firebasestorage.app',
    measurementId: 'G-ZX38GQX2CF',
  );
}
