import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kerawangshop/login.dart';
import 'theme_provider.dart';

class Forgot extends ConsumerStatefulWidget {
  const Forgot({Key? key}) : super(key: key);

  @override
  ConsumerState<Forgot> createState() => _ForgotState();
}

class _ForgotState extends ConsumerState<Forgot> {
  TextEditingController email = TextEditingController();
  reset() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final Color containerBackground = isDarkMode ? const Color(0xFF120A2A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color fieldColor = isDarkMode ? const Color(0xFF1E163A) : const Color(0xFFEDE8FF);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
               Color.fromARGB(255, 107, 49, 255),
               Color.fromARGB(255, 107, 49, 255),
               Color.fromARGB(255, 136, 89, 255),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 107, 49, 255),
              Color.fromARGB(255, 189, 163, 255),
              Color.fromARGB(255, 107, 49, 255),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),

            // Header
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password",        // ✅ Fixed: was "Create Account"
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Enter your email to reset your password",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: containerBackground,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // ✅ Single email field (removed duplicate)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: fieldColor,
                              border: Border.all(color: const Color(0xFF751BF1)),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(93, 93, 93, 0.251),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: email,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ✅ Button now correctly inside the Column's children
                        SizedBox(
                          width: 260,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: reset,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF751BF1),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              "Send Reset Password Link",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}