import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyC3Iz7Ydt_XCd0ffY-xVA84QmtAPnMsKow",
            authDomain: "gobabi-73124.firebaseapp.com",
            projectId: "gobabi-73124",
            storageBucket: "gobabi-73124.firebasestorage.app",
            messagingSenderId: "139624460024",
            appId: "1:139624460024:web:dcb5dacff16f761398150d",
            measurementId: "G-KV0E83FK68"

            // apiKey: "AIzaSyCn_EFb7_Im_gdazHwdus31yJ49cy9abt4",
            // authDomain: "gobabi-32fa6.firebaseapp.com",
            // projectId: "gobabi-32fa6",
            // storageBucket: "gobabi-32fa6.appspot.com",
            // messagingSenderId: "980815100813",
            // appId: "1:980815100813:web:b9a8be26c304fda5521bc4",
            // measurementId: "G-FC99W93529"
            ));
  } else {
    await Firebase.initializeApp();
  }
}
