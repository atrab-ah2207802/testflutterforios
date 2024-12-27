
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/product_provider.dart';

class SearchNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final productTitles = ref.watch(productNotifierProvider).toList().map((product) => (product.title)).toList();
    return productTitles;
  }

List<Product> selectTitle(String title) {
  return ref.watch(productNotifierProvider).toList().where((product) => product.title.toLowerCase() == title.toLowerCase()).toList();
}

  remove(){
    return ref.watch(productNotifierProvider);
  }
}
final searchNotifierProvider =
    NotifierProvider<SearchNotifier, List<String>>(() => SearchNotifier());