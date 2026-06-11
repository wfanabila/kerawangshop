import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kerawangshop/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final user=FirebaseAuth.instance.currentUser;

  signout() async{
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const Login());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFFF7F5FF),
        // Title becomes the search bar
        title: Container(
          height: 50,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDE8FF),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: const Color(0xFF6C4FD4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: const Color(0xFF6C4FD4)),
                      const SizedBox(width: 10),
                      const Text("Search...", style: TextStyle(color: Color(0xFF6C4FD4), fontSize: 16)),
                    ]
                  )
                ),
              ),
            ]
          ),
        ),
        // Cart and Profile icons on the right
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.shopping_cart_outlined, color: Color(0xFF6C4FD4), size: 28,),
          ),
          IconButton(
            onPressed: () {
            
            },
            icon: const Icon(Icons.message_outlined, color: Color(0xFF6C4FD4), size: 28,),
          ),
        ],
      ),
      body: Center(
        child: Text("Welcome, ${user!.email}"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => signout(),
        child: const Icon(Icons.logout_rounded),
      ),
    );
  }
}
