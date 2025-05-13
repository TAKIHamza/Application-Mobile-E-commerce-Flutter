import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dev/user/views/home_view.dart';
import 'package:provider/provider.dart';

import '../../Provider/catigory_provider.dart';
import '../../Provider/themeProvider.dart';
import '../../admin/changeTheme.dart';
import '../../models/product.dart';
import '../../services/products_services.dart';
import '../../widgets/productCard.dart';
import 'favorite_view.dart';

import 'profile_view.dart';
import '../../widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int currentPage = 0;

class _HomePageState extends State<HomePage> {
  
ProductsApi productsApi = ProductsApi();
// ---------------- la liste des containers à afficher dans le body -------------------

  final liste = <Widget>[
    Home_view(),
    Favorite_view(),
    Profile_view(),
    ChangeTheme()
  ];
@override
//--------------------------------------------------------------------------------------
  Widget build(BuildContext context) {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    
    if (categoryProvider.categories.length > 0) {
      categoryProvider.clearCategories();
    }

    return Scaffold(
      appBar: AppBar(elevation: 0.5, actions: [
        if (currentPage == 0)
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search());
              },
              icon: Icon(Icons.search)),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home/cart');
          },
          icon: const Icon(Icons.shopping_cart_outlined),
        )
      ]),
      drawer: const SideBar(),
      extendBody: true,
      body: liste[currentPage],
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
          Icon(Icons.palette, color: Colors.white)
        ],
        height: 60,
        backgroundColor: Colors.transparent,
        color: Provider.of<ThemeProvider>(context).color,
        index: currentPage,
        onTap: (index) => setState(() => currentPage = index),
      ),
    );
  }
}

class Search extends SearchDelegate {
  List<Product> _filteredProducts = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisExtent: 250,
          mainAxisSpacing: 10,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }

  ProductsApi productsApi = ProductsApi();
  String selecedcategory = '';
  late List<Product> products = [];
  @override
  Widget buildSuggestions(BuildContext context) {
      final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    selecedcategory = Provider.of<CategoryProvider>(context).selectedCategory;
    _filteredProducts = products
        .where((product) =>
            product.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: selecedcategory == ""
              ? productsApi.fetchProducts(categoryProvider)
              : productsApi
                  .fetchProductsByCatigory(selecedcategory),
                
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                products = query != "" ? _filteredProducts : snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(8),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: query != ""
                        ? _filteredProducts.length
                        : products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error} ...'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
