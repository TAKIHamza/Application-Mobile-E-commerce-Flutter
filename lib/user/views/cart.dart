import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dev/models/product.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/cartItemCard.dart';
import '../../Provider/cart_provider.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

late double _cartQuantity = 0.0;

TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createCommands(List<Map<String, dynamic>> commands) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/commands');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };
   final request = {
    'commands': commands,
    'adresse': _addressController.text,
    'phoneNumber': _phoneNumberController.text,
  };


    final response = await http.post(
      url,
      body: json.encode(request),
      headers: headers,
    );

    if (response.statusCode == 201) {
      // Commands created successfully
      print('Commands created successfully');
        ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('Commands added successfully')),
                      );
    } else {
      // Error occurred
      print('Error creating commands ');
      print(response.statusCode);
      ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Failed to add Commands ')),
                      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context, listen: false);

    void _deletePoductCart(Product product) {
      setState(() {
        cartProvider.removeFromCart(product);
      });
    }

    void _addToCartQuantity(double number) {
      setState(() {
        _cartQuantity = _cartQuantity + number;
      });
    }

//-------- à modifier (nom de fonction)-------
    void _minimizeCartQuantity(double number) {
      setState(() {
        _cartQuantity = _cartQuantity - number;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = cartProvider.products[index];
                return CartItemCard(
                  product: product,
                  onPressed_delete: _deletePoductCart,
                  onPressed_minimize: _minimizeCartQuantity,
                  onPressed_add: _addToCartQuantity,
                );
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(246, 252, 249, 249),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Price :",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      _cartQuantity.toStringAsFixed(2),
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                
                ElevatedButton(
           child: Text("Chek out"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(300, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                     ),
          onPressed: () {
            if (cartProvider.products.length > 0 && _cartQuantity >0) {
             showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Your adesse and Phone Number '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
           TextButton(
            child: Text('send'),
            onPressed: () {
              if(_addressController.text !="" && _phoneNumberController.text!=""){
                      List<Map<String, dynamic>> commandList = [];
                      for (var i = 0; i < cartProvider.products.length; i++) {
                        if(cartProvider.products[i].cartQuantity>0){
                        Map<String, dynamic> command = {
                          'product_id': cartProvider.products[i].id,
                          'quantity': cartProvider.products[i].cartQuantity,
                        };
                        

                        commandList.add(command);
                        }
                      }
                     
                     
                      createCommands(commandList);
                     }
                      Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
          }},
        ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
