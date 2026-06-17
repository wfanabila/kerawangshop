import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kerawangshop/home_screen.dart';
import 'forgot.dart';
import 'signup.dart';
import 'Animation/FadeAnimation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  login()async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.idToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
  bool isHiddenPassword = true;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> signIn() async {
    try {
      print("Signing in...");

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      print("Login successful");

      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const HomeScreen());

    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);

      Get.snackbar(
        "Login Failed",
        e.message ?? "Unknown error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
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
                children: <Widget> [
                  FadeAnimation(1, Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  SizedBox(height: 10),
                  FadeAnimation(1.3, Text(
                    "Welcome back! Please login to your account.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
                ]
              )
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
                                contentPadding: EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),
                        ),),
                        SizedBox(height: 20),
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
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                          onPressed: () {
                            Get.to(() => const Forgot());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0052DD),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: signIn,
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
                              "Login",
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
                            Get.to(() => const Signup());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF0052DD),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            "Doesn't have an account? Sign up now!",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.center,
                          child: TextButton(
                          onPressed: () {
                            Get.to(() => const Signup());
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF7C7C7C),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            "Or continue with",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (() => login()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8E8E8),
                          foregroundColor: const Color(0xFF4B4B4B),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: Colors.grey.shade300), // border color
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                                width: 24,
                              ),
                              SizedBox(width: 10),
                              Text("Continue with Google", style: TextStyle(fontSize: 16),),
                            ],
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