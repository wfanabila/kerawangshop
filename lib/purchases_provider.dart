import 'package:flutter_riverpod/flutter_riverpod.dart';

class PurchasesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  PurchasesNotifier() : super([]);

  // adds items to the purchase history with a timestamp
  void addPurchasedItems(List<Map<String, dynamic>> items) {
    final now = DateTime.now();
    final updatedItems = items.map((item) {
      return {
        ...item,
        'purchaseDate': "${now.day}/${now.month}/${now.year}",
      };
    }).toList();
    
    state = [...state, ...updatedItems];
  }
}

final purchasesProvider = StateNotifierProvider<PurchasesNotifier, List<Map<String, dynamic>>>((ref) {
  return PurchasesNotifier();
});