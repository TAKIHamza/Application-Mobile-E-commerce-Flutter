import 'package:flutter/material.dart';
class CategoryProvider extends ChangeNotifier {
  List<String> _categories = [];
  String _selectedCategory = '';

  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  void addCategory(String category) {
    _categories.add(category);
    notifyListeners();
  }

  void deleteCategory(String category) {
    _categories.remove(category);
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearSelectedCategory() {
    _selectedCategory = '';
    notifyListeners();
  }
  void clearCategories() {
    _categories.clear();
    
  }
}
