import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/providers/product_provider.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    var favoriteItems = ref.watch(favoritesNotifierProvider);
    final products = ref.watch(productNotifierProvider);


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        title: const Text("My Favorites"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final product = products.firstWhere((product) => product.title == favoriteItems[index].title);

                return GestureDetector(
                  onTap: (){
                        context.push('/details/${product.id}');
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/${product.imageName}',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favoriteItems[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'QR${(product.price).round()}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(favoritesNotifierProvider.notifier).removeFavorite(favoriteItems[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
