import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_provider.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
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
    final isDarkMode = ref.watch(themeProvider);

    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF7F5FF);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;
    final Color purpleTheme = isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2FF7);
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
                      onChanged: (value) {setState(() {searchQuery = value;});},
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
                      final matchesSearch = (product['name'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
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
                                    child: Image.asset(
                                      product['image'] ?? 'assets/images/google.png', 
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
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

  Widget categoryChip(String title, bool isDarkMode) {
    final isSelected = selectedCategory == title;
    final Color purpleTheme = isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2FF7);
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
          side: BorderSide(
            color: purpleTheme,
            width: 1.0,
          ),
        ),
        showCheckmark: false,
      ),
    );
  }
}