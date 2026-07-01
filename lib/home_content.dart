import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sell_screen.dart';
import 'theme_provider.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsStreamProvider);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    final isDarkMode = ref.watch(themeProvider);

    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF7F5FF);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color purpleTheme = const Color(0xFF7B2FF7);
    final Color fieldColor = isDarkMode ? const Color(0xFF1E163A) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundTint,
      body: Container(
        color: backgroundTint,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: fieldColor,
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
                        prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.white70 : Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: purpleTheme, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: purpleTheme, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, color: purpleTheme),
                    iconSize: 28,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryChip("Stationary", isDarkMode),
                    categoryChip("Fashion", isDarkMode),
                    categoryChip("Food & Drinks", isDarkMode),
                    categoryChip("Beauty & Health", isDarkMode),
                    categoryChip("Electronics", isDarkMode),
                    categoryChip("Others", isDarkMode),
                  ],
                ),
              ),
              Expanded(
                child: productsAsync.when(
                  data: (allProducts) {
                    final filteredProducts = allProducts.where((product) {
                      final matchesCategory = selectedCategory == "All" ||
                          (product['category'] ?? '').toLowerCase() == selectedCategory.toLowerCase();
                      final matchesSearch =
                          (product['name'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
                      return matchesCategory && matchesSearch;
                    }).toList();
                    if (filteredProducts.isEmpty) {
                      return Center(child: Text("No products found.", style: TextStyle(color: textColor)));
                    }

                    return GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final bool isMyProduct = product['sellerId'] == currentUserId && currentUserId != null;

                        return Card(
                          color: cardBackground,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: _buildProductImage(product['image']),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'] ?? '',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product['price'] ?? '',
                                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isMyProduct)
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEDE8FF),
                                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SellScreen(productToEdit: product)),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                          onPressed: () => _confirmDelete(context, product['id']),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err", style: TextStyle(color: textColor))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return Image.asset('assets/images/shoes.png', width: double.infinity, fit: BoxFit.cover);
    }
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stack) =>
            Image.asset('assets/images/shoes.png', width: double.infinity, fit: BoxFit.cover),
      );
    }
    return Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover);
  }

  void _confirmDelete(BuildContext context, String? docId) {
    if (docId == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product?"),
        content: const Text("Are you sure you want to permanently remove this listing?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance.collection('products').doc(docId).delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Listing deleted successfully.")),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget categoryChip(String title, bool isDarkMode) {
    final isSelected = selectedCategory == title;
    final Color purpleTheme = const Color(0xFF7B2FF7);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(title),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = (selectedCategory == title) ? "All" : title;
          });
        },
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : (isDarkMode ? Colors.white70 : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        selectedColor: purpleTheme,
        backgroundColor: isDarkMode ? const Color(0xFF221A4A) : const Color(0xFFEDE8FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: purpleTheme, width: 1.0),
        ),
        showCheckmark: false,
      ),
    );
  }
}