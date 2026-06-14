import 'package:flutter/material.dart';
import 'package:kerawangshop/edit_profile.dart';


class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {

  final List<Map<String, dynamic>> products = [
    {'name': 'Popia Carbonara 3pcs', 'price': 'RM5', 'category': 'Food & Drinks', 'image': 'assets/images/popia.png'},
    {'name': 'Sweatshirt', 'price': 'RM15', 'category': 'Fashion', 'image': 'assets/images/sweatshirt.png'},
    {'name': 'WOW Spaghetti Carbonara', 'price': 'RM5', 'category': 'Food & Drinks', 'image': 'assets/images/spaghetti.png'},
    {'name': 'PADINI heels', 'price': 'RM25', 'category': 'Fashion', 'image': 'assets/images/heels.png'},
    {'name': 'Burntcheesecake 1pcs', 'price': 'RM4.50', 'category': 'Food & Drinks', 'image': 'assets/images/burntcheesecake.png'},
    {'name': 'Shoes', 'price': 'RM55', 'category': 'Fashion', 'image': 'assets/images/shoes.png'},
    {'name': 'Dubai Chewy Cookie 1pcs', 'price': 'RM6', 'category': 'Food & Drinks', 'image': 'assets/images/dubaicookie.png'},
    {'name': 'Mineral Water 1pcs', 'price': 'RM1', 'category': 'Food & Drinks', 'image': 'assets/images/mineral.png'},
    {'name': 'Logitech Mouse', 'price': 'RM35', 'category': 'Electronics', 'image': 'assets/images/mouse.png'},
    {'name': 'Wired Earphone', 'price': 'RM20', 'category': 'Electronics', 'image': 'assets/images/earphone.png'},
    {'name': 'PreCalculus Book', 'price': 'RM15', 'category': 'Stationary', 'image': 'assets/images/precalc.png'},
    {'name': 'C++ book', 'price': 'RM15', 'category': 'Stationary', 'image': 'assets/images/cplusplus.png'},


  ];

  List<Map<String, dynamic>> filteredProducts = [];
  String selectedCategory = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void applyFilters() {
    setState(() {
      filteredProducts = products.where((product) {
        final matchesCategory = selectedCategory == "All" ||
            product['category'] == selectedCategory;
        final matchesSearch = product['name']
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void searchProduct(String query) {
    setState(() {
      filteredProducts = products.where((product) {
        return product['name']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  void selectCategory(String category) {
    selectedCategory = (selectedCategory == category) ? "All" : category;
    applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF7F5FF),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: searchProduct,
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

            const SizedBox(height: 20),
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

            Expanded(
              child: GridView.builder(
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
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            product['image'],
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
                                product['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price'],
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
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                "Buy Now",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      )
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
        selectCategory(title);
      },
    ),
  );
}
}
