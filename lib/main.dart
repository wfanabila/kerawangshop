import 'package:flutter/material.dart';
import 'package:kerawangshop/user_profile.dart';
import 'package:kerawangshop/sold_items_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
// import 'package:kerawangshop/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserProfilePage(),
    );
  }
}
