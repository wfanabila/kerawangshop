import 'package:flutter/material.dart';

class MyPurchasesPage extends StatefulWidget {
  const MyPurchasesPage({super.key});

  @override
  State<MyPurchasesPage> createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {
  final List<Map<String, dynamic>> _purchases = [
    {
      'seller': 'MiniBytes',
      'status': 'Delivered',
      'image': 'assets/images/popia.png',
      'name': 'Popia Carbonara',
      'price': 'RM5',
      'rating': '4.8',
    },
    {
      'seller': 'RamenHome',
      'status': 'Delivered',
      'image': 'assets/images/ramen.png',
      'name': 'Buldak Spicy Ramen',
      'price': 'RM6.50',
      'rating': '4.0',
    },
    {
      'seller': 'FreshEgg',
      'status': 'Delivered',
      'image': 'assets/images/egg.png',
      'name': 'Telur Gred A',
      'price': 'RM4.50',
      'rating': '3.9',
    },
    {
      'seller': 'MiniBytes',
      'status': 'Delivered',
      'image': 'assets/images/popia.png',
      'name': 'Popia Carbonara',
      'price': 'RM5',
      'rating': '4.8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);
    const Color backgroundTint = Color(0xFFF3EEFD);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () {
            Navigator.pop(context);
          },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._purchases.map((purchase) => _buildPurchaseCard(
                    sellerName: purchase['seller'],
                    status: purchase['status'],
                    imagePath: purchase['image'],
                    itemName: purchase['name'],
                    price: purchase['price'],
                    rating: purchase['rating'],
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
    required String sellerName,
    required String status,
    required String imagePath,
    required String itemName,
    required String price,
    required String rating,
    required Color primaryPurple,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
                        const SizedBox(width: 12),
                        const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
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

          // buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
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
    );
  }
}