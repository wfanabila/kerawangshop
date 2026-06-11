import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'user_profile.dart';
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:kerawangshop/splash_screen.dart';
>>>>>>> 008f7a4c2a984f7f5175518963037ace1382e8f1

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfilePage(),
    );
  }
}