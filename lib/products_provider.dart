import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addProductToFirestore({
  required String name,
  required String category,
  required String condition,
  required String price,
  required String description,
}) async {
  await FirebaseFirestore.instance.collection('products').add({
    'name': name,
    'category': category,
    'condition': condition,
    'price': 'RM $price',
    'description': description,
    'image': 'assets/images/shoes.png', // Default image fallback
    'createdAt': FieldValue.serverTimestamp(),
  });
}

final productsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true) // Orders newest items first
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          // It's helpful to include the document ID in case you need it for details screens
          var data = doc.data();
          data['id'] = doc.id; 
          return data;
        }).toList();
      });
});