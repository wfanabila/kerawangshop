import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sell_screen.dart';
import 'theme_provider.dart';

class MyListingPage extends ConsumerWidget {
  const MyListingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final Color primaryPurple = isDarkMode ? const Color(0xFF1E163A) : const Color(0xFF7B2CBF);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EFFA);
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

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
                  decoration: BoxDecoration(
                    color: backgroundTint,
                    borderRadius: const BorderRadius.only(
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
                              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                            ),
                            Text("Likes", style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
                            Text("Saves", style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87)),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Empty State Icon
                      Icon(
                        Icons.shopping_cart_checkout,
                        size: 70,
                        color: isDarkMode ? const Color(0xFF7B2FF7) : primaryPurple,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Start selling today !",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 15),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode ? const Color(0xFF7B2FF7) : primaryPurple,
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