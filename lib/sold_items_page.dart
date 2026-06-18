import 'package:flutter/material.dart';

class SoldItemsPage extends StatelessWidget {
  const SoldItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF7B2EFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sold Items",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SoldItemCard(
            productName: "Popia Carbonara",
            buyerName: "Nabila",
            quantity: "x3",
            price: "RM 15",
            date: "20 Sept 2025",
          ),

          SizedBox(height: 10),

          SoldItemCard(
            productName: "Mineral Water 500ml",
            buyerName: "Nabila",
            quantity: "x2",
            price: "RM 4",
            date: "20 Sept 2025",
          ),

          SizedBox(height: 10),

          SoldItemCard(
            productName: "Pelam Lemak",
            buyerName: "Haq",
            quantity: "x1",
            price: "RM 10",
            date: "20 Sept 2025",
          ),

          SizedBox(height: 10),

          SoldItemCard(
            productName: "Mini Chocojar (29g)",
            buyerName: "Siti",
            quantity: "x1",
            price: "RM 1.70",
            date: "18 Sept 2025",
          ),
        ],
      ),
    );
  }
}

class SoldItemCard extends StatelessWidget {
  final String productName;
  final String buyerName;
  final String quantity;
  final String price;
  final String date;

  const SoldItemCard({
    super.key,
    required this.productName,
    required this.buyerName,
    required this.quantity,
    required this.price,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.image, size: 35),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Text(
                  "Buyer : $buyerName",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    Text(quantity),

                    const SizedBox(width: 8),

                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Sold",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                date,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
