import 'package:flutter/material.dart';
import 'package:flutter_dev/Provider/favorite_provider.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../Provider/cart_provider.dart';
import '../user/views/detailProductPage.dart';

class ProductCard extends StatefulWidget {
  
  final Product product;
  const ProductCard({required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<Cart>(context, listen: false);
    final favoriteProvider = Provider.of<Favorites>(context, listen: false);
    bool _isFavorite = favoriteProvider.isFavorit(widget.product);

  
   return GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProductPage(product: widget.product),
      ),
    );
  },
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 120,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Image.network( 'http://127.0.0.1:8000/storage/product/image/${widget.product.image}'),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            widget.product.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4.0),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            '${widget.product.price} DH',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                 _isFavorite = !_isFavorite;
                  if (_isFavorite) {
                    favoriteProvider.addToFavorites(widget.product);
                  } else {
                    favoriteProvider.removeFromFavorites(widget.product);
                  }
                setState(() {
                 

                });
              },
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () {
                if (!cartProvider.incart(widget.product))
                  cartProvider.addToCart(widget.product);
              },
              icon: Icon(Icons.add_shopping_cart_rounded),
            ),
          ],
        ),
      ],
    ),
  ),
);


  }
}
