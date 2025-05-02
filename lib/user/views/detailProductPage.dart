import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../Provider/cart_provider.dart';
import '../../Provider/favorite_provider.dart';



class DetailProductPage extends StatefulWidget {
  final Product product;

  const DetailProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {

  

  @override
  Widget build(BuildContext context) {
          final cartProvider = Provider.of<Cart>(context, listen: false);
          final favoriteProvider = Provider.of<Favorites>(context, listen: false);
    bool _isFavorite = favoriteProvider.isFavorit(widget.product);

    return Scaffold(
     
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                   color: Colors.white,
                  child: Image.network(
                     'http://127.0.0.1:8000/storage/product/image/${widget.product.image}',
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: double.infinity,
                   
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.deepOrangeAccent,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.product.price} DH',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Category:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.product.category,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if(!cartProvider.incart(widget.product))cartProvider.addToCart(widget.product);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart),
                          SizedBox(width: 8),
                          Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                   style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 45), backgroundColor: Colors.deepOrange.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
