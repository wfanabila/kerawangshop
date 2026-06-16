import 'package:flutter/material.dart';
import 'user_profile.dart';
import 'my_listing.dart';
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
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyListingPage(),
    );
  }
}
