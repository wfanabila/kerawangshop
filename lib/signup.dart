import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  bool isHiddenPassword = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signup() async {
  try {

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully"),
      ),
    );

  } on FirebaseAuthException catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.message ?? "Signup failed"),
      ),
    );

    print(e.code);
    print(e.message);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    "Create Account",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Create an account so you can buy and sell items!",
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                        // Email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEDE8FF),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: TextField(
                              controller: email,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),),
                        const SizedBox(height: 20),
                        // Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20,),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEDE8FF),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: TextField(
                              controller: password,
                              obscureText: isHiddenPassword,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isHiddenPassword 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                                  ),
                                            onPressed: () {
                                              setState(() {
                                                isHiddenPassword = !isHiddenPassword;
                                              });
                                            },
                                          ),
                              ),
                            ),
                          ),
                        ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF751BF1),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(50),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                          onPressed: () {
                            Get.to(() => const Login());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0052DD),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            "Already have an account? Sign In",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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