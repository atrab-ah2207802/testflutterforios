import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/repo/repo.dart';

class CategoryNotifier extends Notifier<List<String>> {
  final QuickMartRepo _productRepo = QuickMartRepo();
  List<String> allCategories=[];
  @override
  List<String> build() {
    initializeCategory();
    return [];
  }

  
  void initializeCategory() async {
    var categories = await _productRepo.loadCategories();
    allCategories = categories; 
    state = allCategories;
  }

  
} 

final categoryNotifierProvider =
    NotifierProvider<CategoryNotifier, List<String>>(() => CategoryNotifier());
