import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final dynamic productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;
  bool showDescription = false;

  final productProvider = FutureProvider.autoDispose.family<Product?, String>((ref, id) async {
    final productNotifier = ref.read(productNotifierProvider.notifier);
    return productNotifier.getProductById(id);
  });

  @override
  Widget build(BuildContext context) {
    final productAsyncValue = ref.watch(productProvider(widget.productId));

    return productAsyncValue.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => const Center(
        child: Text("Error"),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Product Details')),
            body: const Center(child: Text('Product not found')),
          );
        }

        final favorites = ref.watch(favoritesNotifierProvider);
        bool isFavorite = favorites.any((fav) => fav.id == product.id);

        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/${product.imageName}',
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_rounded,
                        color: isFavorite ? Colors.green : null,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          ref.read(favoritesNotifierProvider.notifier).removeFavorite(product);
                        } else {
                          ref.read(favoritesNotifierProvider.notifier).addToFavorites(product);
                        }
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (quantity > 1) setState(() => quantity--);
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                    Text(
                      "QR${(product.price * quantity).round()}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product Details"),
                    IconButton(
                      icon: Transform.rotate(
                        angle: showDescription ? 3.14159 / 2 : 0,
                        child: const Icon(Icons.arrow_forward),
                      ),
                      onPressed: () {
                        setState(() {
                          showDescription = !showDescription;
                        });
                      },
                    ),
                  ],
                ),
                if (showDescription) Text(product.description),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Nutrition"),
                    const SizedBox(width: 10),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Rating"),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < product.rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        );
                      }),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final cartItem = CartItem(
                          productId: product.id,
                          quantity: quantity,
                        );
                        ref.read(cartNotifierProvider.notifier).addToCart(cartItem);
                        context.goNamed(AppRouter.cart.name);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text(
                        "Add to basket",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
