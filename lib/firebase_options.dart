// Конфигурация Firebase для всех платформ.
// Для Web: добавьте веб-приложение в Firebase Console и замените webAppId.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return web; // Windows использует web-конфиг
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions не поддерживаются для этой платформы.',
        );
    }
  }

  /// Web-конфиг. appId нужен после добавления веб-приложения в Firebase Console.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA4iNzw7UVcY_b-G-f4dg9XqNRxMSW21M8',
    appId: '1:1005581184078:web:REPLACE_WITH_REAL_WEB_APP_ID',
    messagingSenderId: '1005581184078',
    projectId: 'edymyapp',
    authDomain: 'edymyapp.firebaseapp.com',
    storageBucket: 'edymyapp.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4iNzw7UVcY_b-G-f4dg9XqNRxMSW21M8',
    appId: '1:1005581184078:android:857a2be51c2498eaebe71f',
    messagingSenderId: '1005581184078',
    projectId: 'edymyapp',
    storageBucket: 'edymyapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4iNzw7UVcY_b-G-f4dg9XqNRxMSW21M8',
    appId: '1:1005581184078:ios:placeholder',
    messagingSenderId: '1005581184078',
    projectId: 'edymyapp',
    storageBucket: 'edymyapp.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4iNzw7UVcY_b-G-f4dg9XqNRxMSW21M8',
    appId: '1:1005581184078:ios:placeholder',
    messagingSenderId: '1005581184078',
    projectId: 'edymyapp',
    storageBucket: 'edymyapp.firebasestorage.app',
  );
}
