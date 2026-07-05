import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';
import 'stripe_payment_screen.dart';
import 'theme_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  Widget _buildCartImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/images/shoes.png', width: 50, fit: BoxFit.cover);
    }
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            Image.asset('assets/images/shoes.png', width: 50, fit: BoxFit.cover),
      );
    }
    return Image.asset(imagePath, width: 50, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.read(cartProvider.notifier).totalPrice;
    final isDarkMode = ref.watch(themeProvider);

    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF7F5FF);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        title: Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: textColor)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                "Your cart is empty!",
                style: TextStyle(fontSize: 18, color: isDarkMode ? Colors.white70 : Colors.black87),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        color: cardBackground,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: _buildCartImage(item['image']),
                          title: Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item['price'] ?? '', style: const TextStyle(color: Colors.green)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeFromCart(item['id']);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                          Text(
                            "RM ${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B2FF7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StripePaymentScreen(amount: totalPrice),
                              ),
                            );
                          },
                          child: const Text("Proceed to Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}