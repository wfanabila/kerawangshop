import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';
import 'favorites_provider.dart';
import 'theme_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF7F5FF);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color purpleTheme = isDarkMode ? const Color(0xFF7B2FF7) : Colors.deepPurple;

    final favoriteList = ref.watch(favoritesProvider);
    final isLiked = favoriteList.any((item) => item['name'] == product['name']);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product['image'] ?? 'assets/images/shoes.png',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['price'] ?? '',
                    style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(product['category'] ?? 'General', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87)),
                    backgroundColor: isDarkMode ? const Color(0xFF1E163A) : Colors.deepPurple.shade50,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: purpleTheme),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'No description provided.',
                    style: TextStyle(fontSize: 16, height: 1.5, color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: cardBackground,
        child: SafeArea(
          child: Row(
            children: [
              // like button
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: isLiked ? Colors.red.shade50 : (isDarkMode ? const Color(0xFF1E163A) : Colors.grey.shade50), // Changes dynamically
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isLiked ? Colors.red.shade200 : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)),
                ),
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border, 
                    color: isLiked ? Colors.red : Colors.grey, 
                    size: 28,
                  ),
                  onPressed: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(product);
                    
                    ScaffoldMessenger.of(context).clearSnackBars(); // Prevents stacking snackbars
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isLiked 
                              ? "${product['name']} removed from favorites!" 
                              : "${product['name']} added to favorites!",
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15), 
              
              // add to cart button
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B2FF7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ref.read(cartProvider.notifier).addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product['name']} added to cart!")),
                      );
                    },
                    child: const Text("Add To Cart", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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