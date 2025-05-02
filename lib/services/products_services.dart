import 'dart:convert';

import 'package:flutter_dev/models/product.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/catigory_provider.dart';

class ProductsApi {
  Future<List<Product>> fetchProducts(CategoryProvider categoryProvider) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/products'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Product> Products = [];
      
      for (var ProductJson in jsonData["Products"]) {
        Products.add(Product.fromJson(ProductJson));
      }
      if(categoryProvider.categories.length==0)
     { for (var CategoryJson in jsonData["Categorys"]) {
        categoryProvider.addCategory(CategoryJson["name"]);
      }
      categoryProvider.addCategory("");}
      return Products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<Product>> fetchProductsByCatigory(String category) async {
    final url =
        Uri.parse('http://127.0.0.1:8000/api/products/by-category/$category');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Product> Products = [];

      for (var ProductJson in jsonData["Products"]) {
        Products.add(Product.fromJson(ProductJson));
      }

      return Products;
    } else {
      print(category);
      print(response.statusCode);
      return [];
      //  throw Exception('Failed to fetch products');
    }
  }
}
