import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/product_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  var total=0;
  @override
  Widget build(BuildContext context) {
    var cartItems = ref.watch(cartNotifierProvider);
    final products = ref.watch(productNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(cartNotifierProvider.notifier).clearCart(); 
          },
        ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); 
          },
        ),
        title: const Text("My Cart"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
            itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = products.firstWhere((product) => product.id == cartItems[index].productId);
                
                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      'assets/images/${product.imageName}',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    title: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(fontSize: product.title.length>30? 15:18,fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_rounded),
                                  onPressed: () {
                                  
                                      if(cartItems[index].quantity==1){
                                      ref.read(cartNotifierProvider.notifier).removeFromCart(cartItems[index]);}
                                      else{
                                      ref.read(cartNotifierProvider.notifier).updateQuantity(cartItems[index],(-1));
                                    }
                                  },
                                ),
                                Text(cartItems[index].quantity.toString()),
                                IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  onPressed: () {
                                    
                                      ref.read(cartNotifierProvider.notifier).updateQuantity(cartItems[index],(1));
                                    
                                    
                                    
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                
                                   ref.read(cartNotifierProvider.notifier).removeFromCart(cartItems[index]);
                                  //total-=(cartItems[index].unitPrice * cartItems[index].quantity).round();
                                
                               
                              },
                            ),
                            Text('QR${(product.price * cartItems[index].quantity).round()}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize:16),),
                          
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
           
            },
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.0), 
    ),
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(15), 
            ),
            child:  Text("Go to Checkout   ${ref.read(cartNotifierProvider.notifier).calculateTotal(cartItems).round()}  ", style:TextStyle(color: Colors.white,),
          ),
        ),
        ),
      ],
    
    ),
  ),
),

        
        ],
      ),
    );
  }
}
