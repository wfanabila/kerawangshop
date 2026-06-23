import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StreamProvider automatically listens to real-time updates from Firestore
final productsStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  return FirebaseFirestore.instance.collection('products').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id; // Store document ID if you need to pass it to a details page
      return data;
    }).toList();
  });
});