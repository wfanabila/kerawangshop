import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoritesNotifier() : super([]);

  void toggleFavorite(Map<String, dynamic> product) {
    final isExist = state.any((item) => item['name'] == product['name']);
    if (isExist) {
      state = state.where((item) => item['name'] != product['name']).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(Map<String, dynamic> product) {
    return state.any((item) => item['name'] == product['name']);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Map<String, dynamic>>>((ref) {
  return FavoritesNotifier();
});