import 'package:go_router/go_router.dart';
import 'package:quickmart/screens/cart_screen.dart';
import 'package:quickmart/screens/favorites_screen.dart';
import 'package:quickmart/screens/product_details_screen.dart';
import 'package:quickmart/screens/product_screen.dart';
import 'package:quickmart/screens/shell_screen.dart';

class AppRouter {
  static const product = (name: 'product', path: '/');
  static const cart = (name: 'cart', path: '/cart');
  static const favorites = (name: 'favorites', path: '/favorites');
  static const details = (name: 'details', path: '/details/:productId');

  static final router = GoRouter(
    initialLocation: product.path,
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: product.path,
            name: product.name,
            builder: (context, state) => const ProductsScreen(),
            routes: [
              GoRoute(
                path: details.path,
                name: details.name,
                builder: (context, state) {
                    final productId=state.pathParameters['productId'];
                    return ProductDetailsScreen(productId:productId!);
                },
              ),
            ],
          ),
          GoRoute(
            path: favorites.path,
            name: favorites.name,
            builder: (context, state) => const FavoritesScreen(),
          ),
        ],
      ),
      GoRoute(
        path: cart.path,
        name: cart.name,
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );
}
