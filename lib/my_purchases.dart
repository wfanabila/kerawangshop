import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'purchases_provider.dart';
import 'product_detail_screen.dart';

class MyPurchasesPage extends ConsumerStatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  ConsumerState<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends ConsumerState<MyPurchasesPage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);
    const Color backgroundTint = Color(0xFFF3EEFD);

    final dynamicPurchases = ref.watch(purchasesProvider);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Purchases',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: dynamicPurchases.isEmpty
          ? const Center(
              child: Text(
                "You haven't bought anything yet!",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    ...dynamicPurchases.map((purchase) => _buildPurchaseCard(
                          productRawData: purchase, // Pass whole map to route details
                          sellerName: purchase['seller'] ?? 'General Store',
                          status: 'Delivered', 
                          imagePath: purchase['image'] ?? 'assets/images/google.png',
                          itemName: purchase['name'] ?? '',
                          price: purchase['price'] ?? 'RM0.00',
                          primaryPurple: primaryPurple,
                        )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPurchaseCard({
    required Map<String, dynamic> productRawData,
    required String sellerName,
    required String status,
    required String imagePath,
    required String itemName,
    required String price,
    required Color primaryPurple,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: productRawData),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.storefront, color: primaryPurple, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      sellerName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
                  ],
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: primaryPurple,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFFF3EEFD),
                      child: Icon(Icons.image_outlined, color: primaryPurple, size: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              color: primaryPurple,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: productRawData),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Buy Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}