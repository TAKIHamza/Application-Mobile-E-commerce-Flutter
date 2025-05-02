import 'package:flutter/material.dart';
import 'package:flutter_dev/models/product.dart';
import 'package:provider/provider.dart';

import '../Provider/cart_provider.dart';

class CartItemCard extends StatefulWidget {
  final Product product;
  final Function onPressed_delete;
  final Function onPressed_minimize;
  final Function onPressed_add;

  CartItemCard(
      {required this.product,
      required this.onPressed_delete,
      required this.onPressed_minimize,
      required this.onPressed_add});

  @override
  _CartItemCardState createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  int _itemQuantity = 0;
  
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.network(
                'http://127.0.0.1:8000/storage/product/image/${widget.product.image}',
                height: 95,
                width: 90,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 148,
                    child: Text(
                      widget.product.title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 14, 0, 0),
                    child: Text(
                      "${widget.product.price}",
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
                    widget.onPressed_minimize(widget.product.price*widget.product.cartQuantity);
                    widget.onPressed_delete(widget.product);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  )),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                ),
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            widget.product.cartQuantity++;
                            widget.onPressed_add(widget.product.price);
                          });
                        },
                        icon: Icon(
                          Icons.add,
                          size: 20,
                        )),
                    Text(widget.product.cartQuantity.toString()),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            if (widget.product.cartQuantity > 0) {
                              widget.product.cartQuantity--;
                              widget.onPressed_minimize(widget.product.price);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.minimize,
                          size: 23,
                        ),
                        padding: EdgeInsets.only(bottom: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
