import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Provider/catigory_provider.dart';
import '../services/products_services.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _nameController = TextEditingController();
   ProductsApi productsApi = ProductsApi();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _addCategory() async {
    if (_nameController.text.isNotEmpty) {
      final token = await _getToken();
      if (token == null) {
        // Token not found in shared preferences
        // Handle the error
        return;
      }

      final request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:8000/api/categorys'));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = _nameController.text;

      final response = await request.send();
      if (response.statusCode == 201) {
        // Product added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Catrgory added successfully.'),
          ),
        );
      } else {
        // Error adding product
        print(response.statusCode);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error adding Category.'),
          ),
        );
      }
    }
  }

  Future<void> deleteCategory(String category) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/categorys/${category}');
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

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Catrgory deleted successfully.'),
          ),
        );
    } else {
      // Error deleting user
      print('Error deleting Product. ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error delete Category.'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final categories = categoryProvider.categories;
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Category',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      _addCategory();
                      if(categoryProvider.categories.length>0){ categoryProvider.clearCategories();}
                      productsApi.fetchProducts(categoryProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(category),
                      ),
                      if (category != '')
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteCategory(category);
                            if(categoryProvider.categories.length>0){ categoryProvider.clearCategories();}
                            productsApi.fetchProducts(categoryProvider);
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
