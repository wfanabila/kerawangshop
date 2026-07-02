import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerListingPage extends StatefulWidget {
  const SellerListingPage({super.key});

  @override
  State<SellerListingPage> createState() => _SellerListingPageState();
}

class _SellerListingPageState extends State<SellerListingPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Listings")),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No listings yet"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final product = snapshot.data!.docs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(product['price']),
                      const SizedBox(height: 4),
                      Text(product['category'] ?? ''),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Delete Listing"),
                                  content: const Text(
                                    "Are you sure you want to delete this listing?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(product.id)
                                .delete();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Listing deleted successfully!"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
