import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repo/repo.dart';

class ProductNotifier extends Notifier<List<Product>> {
  
  final QuickMartRepo _productRepo = QuickMartRepo();
  List<Product> products = [];
  
  @override
  List<Product> build() {
    initializeProducts();
    return [];
  }
  void initializeProducts() async {
    var products = await _productRepo.loadProducts();
    state = products;
  }

    getProductByTitle(String title) {
    return _productRepo.getProductByTitle(title);
}

    getProductsByCategory (List<String> category) async{
      var products=await _productRepo.getProductsByCategory(category);
        state = products;
      
    }

     getProductById (String productId) {
      return _productRepo.getProductById(productId);
      //return state.firstWhere((state)=>state.id==productId);
    }

    getProducts(){
      return state;
    }
}

final productNotifierProvider =
    NotifierProvider<ProductNotifier, List<Product>>(() => ProductNotifier());


