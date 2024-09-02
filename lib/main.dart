import 'package:app_banhang/Login/Login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Cấu hình Firebase dựa trên nền tảng
  if (kIsWeb) {
    // Firebase Web Initialization
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBw1BqBB4a7XCDsklmxNB3KRd0liM8zcHo",
          authDomain: "appbanhang-16770.firebaseapp.com",
          projectId: "appbanhang-16770",
          storageBucket: "appbanhang-16770.appspot.com",
          messagingSenderId: "1052330785818",
          appId: "1:1052330785818:web:2c7561d7f698054e1c65a3",
          measurementId: "G-RMHBN4NSNG",
      ),
    );
  } else {
    // Firebase Android Initialization
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

<<<<<<< HEAD

// taài khoản login:
// tk: lo@gmail.com hoặc l@gmail.com
// mk: 123456
=======
// taài khoản login:
// tk: lo@gmail.com hoặc l@gmail.com
// mk: 123456
>>>>>>> e9d1a09ffd5d6aa743655cbb1423ff069bfaf746
