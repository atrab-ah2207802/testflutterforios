import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';

class QuickMartRepo{
final Dio _dio=Dio();
  final String _baseUrl = 'https://quickmart.codedbyyou.com/api';
 
  Future<List<Product>> loadProducts() async {
    //String data = await rootBundle.loadString('assets/data/products.json');
    Response response = await _dio.get('$_baseUrl/products');
    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }
   
    List<Product> products = [];
    for (var productMap in response.data) {
      products.add(Product.fromJson(productMap));
    }
    return products;

  }

  Future<Product> getProductById(String productId) async {
    Response response = await _dio.get('$_baseUrl/products/$productId');
    if (response.statusCode != 200) {
      throw Exception('Failed to load product');
    }
      return Product.fromJson(response.data);

    
  }
  Future<Product> getProductByTitle(String title) async {
    Response response = await _dio.get('$_baseUrl/products/search?name=$title');
    if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }
    return Product.fromJson(response.data);
  }

  Future <List<Product>> getProductsByCategory(List<String> categories) async {
    String splitedCategory = categories.join(',');
     Response response = await _dio.get('$_baseUrl/products/search?name=&category=$splitedCategory');
      if (response.statusCode != 200) {
      throw Exception('Failed to load products');
    }
   List<Product> products = [];
    for (var productMap in response.data) {
      products.add(Product.fromJson(productMap));
    }
    return products;
  }
   
    Future<List<CartItem>> loadCart() async {
    Response response = await _dio.get('$_baseUrl/cart');
    if (response.statusCode != 200) {
      throw Exception('Failed to load cart');
    }
   
    List<CartItem> cart = [];
    for (var cartMap in response.data) {
      cart.add(CartItem.fromJson(cartMap));
    }
    return cart;

  }
    Future<CartItem> addToCart(CartItem item) async {
    final url = '$_baseUrl/cart';
    Response response = await _dio.post(url, data:{
      'productId': item.productId,
      'quantity': item.quantity,
    });
    if (response.statusCode != 201) {
     throw Exception('Failed to add to cart');
    }
    return CartItem.fromJson(response.data);

  }

  Future<void> updateQuantity(String productId, int quantity) async {
   
    Response response = await _dio.put('$_baseUrl/cart/$productId',data: {"quantity":quantity});
    if (response.statusCode != 201) {
      throw Exception('Failed to add Cart');
    }
   }

  Future<bool> removeFromCart (CartItem item) async {
    final url = '$_baseUrl/cart/${item.productId}'; 
    Response response = await _dio.delete(url);
    if (response.statusCode != 204) {
     throw Exception('Failed to remove Item form cart');
    }
     return true;
  }

  Future<bool> clearCart () async{
    final url='$_baseUrl/cart';
    Response response = await _dio.delete(url);
    if (response.statusCode != 204) {
     throw Exception('Failed to clear cart');
    }
     return true;

  }

    Future<List<Product>> loadFavorites() async {
    
    Response response = await _dio.get('$_baseUrl/favorites');
    if (response.statusCode != 200) {
      throw Exception('Failed to load favorites');
    }
    List<String> favouritesId=[];
    for (var productMap in response.data) {
      favouritesId.add(productMap["productId"]);
    }
    List<Product> products = await loadProducts();
    List<Product> favouritesProducts =products.where((product)=> favouritesId.contains(product.id)).toList();
    return favouritesProducts;
  }

  Future<Product> addToFavorites(Product product) async {
    final url = '$_baseUrl/favorites';
    Response response = await _dio.post(url, data:{
      'productId': product.id,
    });
    if (response.statusCode != 201) {
     throw Exception('Failed to add to favorites');
    }
    return Product.fromJson(response.data);

  }

  Future<bool> removeFromFavorites(Product product) async {
    final url='$_baseUrl/favorites/${product.id}';
    Response response = await _dio.delete(url);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete from favorites');
    }
    return true;
   
  }

   Future<List<String>> loadCategories() async {
  
  Response response = await _dio.get('$_baseUrl/categories');
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }
   
    
    return List<String>.from(response.data);
 
  }
  


  


   
}