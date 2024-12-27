import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/cart_item.dart';

import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/category_provider.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/routes/app_router.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {

  Map<String, int> quantity={};
  Map<String, bool> checkboxStates = {};
  bool isFiltering = false;
  List<String> categorySelected = [];
  bool bySearch = false;
  final textField = TextEditingController();
  String title = '';

  @override
  Widget build(BuildContext context) {
    var products = ref.watch(productNotifierProvider);
    List<String> categories=ref.read(categoryNotifierProvider.notifier).allCategories;
    var cartItems=ref.watch(cartNotifierProvider);
     if (quantity.isEmpty) {
    for (var product in products) {
      var matchingItems = cartItems.where((item) => item.productId == product.id).toList();

      if (matchingItems.isNotEmpty) {
        quantity[product.id] = matchingItems.first.quantity;
      } else {
        quantity[product.id] = 0;
      }
    }
  }
 
    if (bySearch && title.isNotEmpty) {
      products = products.where((product) =>
          product.title.toLowerCase().contains(title.toLowerCase())).toList();
    }

    if (isFiltering) {
    ref.read(productNotifierProvider.notifier).getProductsByCategory(categorySelected);
    }
    else{
      ref.read(productNotifierProvider.notifier).initializeProducts();
    }

    int dialogCount=1;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 236, 231, 231),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: textField,
                    onSubmitted: (value) {
                      setState(() {
                        bySearch = true;
                        title = textField.text;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Search",
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            bySearch = true;
                            title = textField.text;
                          });
                        },
                        icon: const Icon(Icons.search),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 240, 236, 236),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: () {
                  setState(() {
                    // Reset filters
                    isFiltering = false;
                    bySearch = false;
                    categorySelected.clear();
                    checkboxStates = {};
                    title = '';
                    textField.clear();
                  });
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Category filters section
            Wrap(
              spacing: 10,
              children: categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: checkboxStates[category] ?? false,
                  onSelected: (selected) {
                    setState(() {
                      checkboxStates[category] = selected;
                      if (selected) {
                        categorySelected.add(category);
                      } else {
                        categorySelected.remove(category);
                      }
                      isFiltering = categorySelected.isNotEmpty;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var item = products[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/details/${item.id}');
                    },
                    child: Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.asset(
                              'assets/images/${item.imageName}',
                              fit: BoxFit.cover,
                              height: 100,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: item.title.length>30? 15:18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item.category,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "QR${item.price.round()}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: StatefulBuilder(
                                              builder: (context, setStateDialog) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(products[index].title),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                              IconButton(
                                                              icon: const Icon(Icons.remove),
                                                              onPressed: () {
                                                                setStateDialog(() {
                                                                  if (dialogCount > 1) dialogCount--;
                                                                });
                                                              },
                                                            ),
                                                            
                                                            Text( dialogCount.toString()),
                                                          
                                                          IconButton(
                                                              icon: const Icon(Icons.add),
                                                              onPressed: () {
                                                                setStateDialog(() {
                                                                  dialogCount++;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          "QR${(item.price * dialogCount).round()}",
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 20),
                                                    ElevatedButton(
                                                    onPressed: () {
                                                      final cartItem = CartItem(
                                                        productId: item.id,
                                                        quantity: dialogCount,
                                                      );
                                                      ref.read(cartNotifierProvider.notifier).addToCart(cartItem);
                                                      context.goNamed(AppRouter.cart.name);
                                                    },
                                                    child: const Text("Add to Basket"),
                                                  ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },

                                      icon: const Icon(
                                        Icons.add_box_rounded,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
