import 'package:flutter/material.dart';

class Cart_Dialog extends StatefulWidget {
  @override
  _Cart_DialogState createState() => _Cart_DialogState();
}

class _Cart_DialogState extends State<Cart_Dialog> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(' Dialog'),
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
      ],
    );
  }
}
