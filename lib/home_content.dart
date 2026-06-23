import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kerawangshop/edit_profile.dart';
import 'products_provider.dart'; // Import your new provider

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
    // Watch the Firestore stream provider
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      body: Container(
        color: const Color(0xFFF7F5FF),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- SEARCH BAR ROW ---
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF7B2FF7), width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Color(0xFF7B2FF7)),
                    iconSize: 28,
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- CATEGORY FILTERS ---
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryChip("Stationary"),
                    categoryChip("Fashion"),
                    categoryChip("Food & Drinks"),
                    categoryChip("Beauty & Health"),
                    categoryChip("Electronics"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- GRID LIST DRIVEN BY RIVERPOD & FIRESTORE ---
              Expanded(
                child: productsAsync.when(
                  // 1. Data arrived successfully
                  data: (allProducts) {
                    // Filter the products list dynamically based on search & category
                    final filteredProducts = allProducts.where((product) {
                      final matchesCategory = selectedCategory == "All" || 
                          (product['category'] ?? '').toLowerCase() == selectedCategory.toLowerCase();
                      final matchesSearch = (product['name'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
                      return matchesCategory && matchesSearch;
                    }).toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(child: Text("No products found."));
                    }

                    return GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product['price'] ?? '',
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: EditProfilePage.new,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF751BF1),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: const Text("Buy Now", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  // 2. Loading state handler
                  loading: () => const Center(child: CircularProgressIndicator()),
                  // 3. Error state handler
                  error: (err, stack) => Center(child: Text("Error: $err")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryChip(String title) {
    final isSelected = selectedCategory == title;
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
      ),
    );
  }
}