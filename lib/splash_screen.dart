import 'package:flutter/material.dart';
import 'package:kerawangshop/login.dart';
import 'package:lottie/lottie.dart';
<<<<<<< HEAD
// import 'home_screen.dart';
=======
>>>>>>> 008f7a4c2a984f7f5175518963037ace1382e8f1

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationLoaded(LottieComposition composition) {
    _controller
      ..duration = composition.duration
      ..forward().whenComplete(_navigateToHome);
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/Lottie/shopping.json',
              controller: _controller,
              onLoaded: _onAnimationLoaded,
              width: 700,
              height: 700,
            ),
            const SizedBox(height: 24),
            const Text(
              'KERAWANG SHOP',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your shopping companion',
              style: TextStyle(
                color: Color.fromARGB(137, 251, 6, 6),
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}