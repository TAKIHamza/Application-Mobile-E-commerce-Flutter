import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dev/admin/update_product.dart';

import '../Provider/catigory_provider.dart';
import '../models/product.dart';
import '../services/products_services.dart';

import 'package:http/http.dart' as http;

class Products_view_admin extends StatefulWidget {
  const Products_view_admin({super.key});

  @override
  State<Products_view_admin> createState() => _Products_view_adminState();
}

class _Products_view_adminState extends State<Products_view_admin> {
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/products/${productId}');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };

    final response = await http.delete(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      //  deleted successfully

      print('Product deleted successfully.');
    } else {
      // Error deleting user
      print('Error deleting Product. ${response.body}');
    }
  }
 ProductsApi productsApi = ProductsApi();
  String selecedcategory = '';
  @override
 
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context,listen: false );
    

    
      selecedcategory = Provider.of<CategoryProvider>(context).selectedCategory;

    return Scaffold(
      body: FutureBuilder<List<Product>>(
          future: selecedcategory == ""
              ? productsApi.fetchProducts(categoryProvider)
              : productsApi
                  .fetchProductsByCatigory(selecedcategory),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = snapshot.data!;

              return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                'http://127.0.0.1:8000/storage/product/image/${products[index].image}',
                                height: 95,
                                width: 90,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 14, 0, 0),
                                    child: SizedBox(
                                      width: 148,
                                      child: Text(
                                        products[index].title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 14, 0, 0),
                                    child: Text(
                                      "${products[index].price} DH",
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    deleteProduct(products[index].id);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Update_Product(
                                            product: products[index]),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.mode_edit_outline_outlined,
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
