import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/repo/repo.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  final QuickMartRepo _productRepo = QuickMartRepo();
  
  @override
  List<CartItem> build() {
    initializeCart();
    return [];
  }

  void initializeCart() async {
    var cart = await _productRepo.loadCart();
    state = cart;
  }


  void addToCart(CartItem item) {
  final existingItemIndex = state.indexWhere((c) => c.productId == item.productId);
  if (existingItemIndex == -1) {
    _productRepo.addToCart(item).then((newItem) {
      state = [...state, newItem];
    });
  } else {
    updateQuantity(item, item.quantity);
  }
}

  void updateQuantity(CartItem item, int quantity) {
  final index = state.indexWhere((c) => c.productId == item.productId);
  if (index == -1) return; 
  final tempState = List<CartItem>.from(state);
  if (quantity == 1) {
    tempState[index].quantity += 1;
  } else if (quantity == -1) {
    tempState[index].quantity -= 1;
  } else {
    tempState[index].quantity += quantity;
  }
  state = tempState;
  _productRepo.updateQuantity(item.productId, tempState[index].quantity).then((_) {
    initializeCart();
  });
}

  
  
  removeOne(CartItem item){
    final existingItemIndex = state.indexWhere((cartItem) => cartItem.productId == item.productId);
  
      final existingItem = state[existingItemIndex];
      state[existingItemIndex] = CartItem(
        productId: existingItem.productId,
        quantity: existingItem.quantity - 1,
       );
  }
  void removeFromCart(CartItem item) async{
    
    bool isRemoved = await _productRepo.removeFromCart(item);
    if (isRemoved) {
      state = state.where((c) => c.productId != item.productId).toList();
    }
  
  }
double calculateTotal(List<CartItem> cartItems) {
  
  var products=ref.read(productNotifierProvider.notifier).getProducts();
  return cartItems.fold(0.0, (total, cartItem) => total + (products.firstWhere((product)=>product.id==cartItem.productId).price * cartItem.quantity));
}

void clearCart() async{
   bool isRemoved = await _productRepo.clearCart();
    if (isRemoved) {
      state = [];
    }
}



}


final cartNotifierProvider = NotifierProvider<CartNotifier, List<CartItem>>(
  () => CartNotifier(),
);
