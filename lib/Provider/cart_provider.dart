import 'package:flutter/material.dart';
import '../models/product.dart';

class Cart with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => _products;

  void addToCart(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _products.remove(product);
    notifyListeners();
  }

   bool incart(Product product) {
  return _products.any((cartProduct) => cartProduct.id == product.id);
  } 
}
