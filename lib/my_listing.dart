import 'package:flutter/material.dart';
import 'sell_screen.dart';

class MyListingPage extends StatelessWidget {
  const MyListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);

    return Scaffold(
      backgroundColor: primaryPurple,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              const CircleAvatar(radius: 40, backgroundColor: Colors.white),

              const SizedBox(height: 30),

              const Text(
                "LEEHAN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "⭐ 5.0 (44 reviews)",
                style: TextStyle(color: Colors.white),
              ),

              const Text("Active today", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 30),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3EFFA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Tabs
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Selling",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("Likes"),
                            Text("Saves"),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Empty State Icon
                      Icon(
                        Icons.shopping_cart_checkout,
                        size: 70,
                        color: primaryPurple,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Start selling today !",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SellScreen(),
                            ),
                          );
                        },
                        child: const Text("List an item"),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
