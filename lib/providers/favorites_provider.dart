import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repo/repo.dart';

class FavoritesNotifier extends Notifier<List<Product>> {
  List<Product> favorites=[];
  final QuickMartRepo _productRepo = QuickMartRepo();
  @override
  List<Product> build() {
    initializeFavorites() ;
    return [];
  }

  void initializeFavorites() async {
    var favorites = await _productRepo.loadFavorites();
    state = favorites;
  }

 
  void addToFavorites(Product product) async{
    state=[...state,  await _productRepo.addToFavorites(product) ];
    initializeFavorites();
  }

  void removeFavorite(Product product) async{
     bool isRemoved = await _productRepo.removeFromFavorites(product);
    if (isRemoved) {
      state = state.where((p) => p.title != product.title).toList();
    }
  }

   bool isFavorite(Product product) {
    initializeFavorites();
    return favorites.any((fav) => fav.id == product.id); 
  }
}

final favoritesNotifierProvider =
    NotifierProvider<FavoritesNotifier, List<Product>>(
        () => FavoritesNotifier());
