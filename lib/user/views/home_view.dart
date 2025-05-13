import 'package:flutter/material.dart';
import 'package:flutter_dev/models/product.dart';
import 'package:provider/provider.dart';

import '../../Provider/catigory_provider.dart';
import '../../services/products_services.dart';

import '../../widgets/productCard.dart';

class Home_view extends StatefulWidget {
  @override
  State<Home_view> createState() => _Home_viewState();
}

class _Home_viewState extends State<Home_view> {
  
  ProductsApi productsApi = ProductsApi();
String selecedcategory = '';
@override
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final categories = categoryProvider.categories;
    
selecedcategory = Provider.of<CategoryProvider>(context).selectedCategory;
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        body: Column(
          children: [
            
            Expanded(
              child: FutureBuilder<List<Product>>(
                future:  selecedcategory == ""
              ? productsApi.fetchProducts(categoryProvider)
              : productsApi
                  .fetchProductsByCatigory(selecedcategory),
                
                builder: (context, snapshot) {
                  
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data!;
                    
                    return Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisExtent: 245,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ProductCard(product: products[index]);
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ));
  }
}
