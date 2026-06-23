import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  CartNotifier() : super([]);

  void addToCart(Map<String, dynamic> product) {
    // Prevent duplicate entries by incrementing or simply checking existence
    if (!state.any((item) => item['id'] == product['id'])) {
      state = [...state, product];
    }
  }

  void removeFromCart(String id) {
    state = state.where((item) => item['id'] != id).toList();
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in state) {
      // Strips away "RM " text to read raw numeric price data cleanly
      final priceString = (item['price'] ?? '0').replaceAll('RM', '').trim();
      total += double.tryParse(priceString) ?? 0.0;
    }
    return total;
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Map<String, dynamic>>>((ref) {
  return CartNotifier();
});