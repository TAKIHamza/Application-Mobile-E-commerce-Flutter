import 'package:flutter/material.dart';
import '../models/product.dart';

class Favorites with ChangeNotifier {
  
   final List<Product> _products = [];
  List<Product> get products => _products;

  void addToFavorites(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeFromFavorites(Product product) {
    _products.remove(product);
    notifyListeners();
  }

  bool isFavorit(Product product) {
  return _products.any((favoritProduct) => favoritProduct.id == product.id);
}

}
