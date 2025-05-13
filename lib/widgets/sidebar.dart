import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/catigory_provider.dart';



class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
 
  late Map<String, dynamic>  user = {'name':'','email':''};

  @override
  void initState() {
    super.initState();
    getUserFromSharedPreferences();
  }

  Future<void> getUserFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUser = prefs.getString('user');
    setState(() {
      user = jsonDecode(storedUser!) ; // Assign the stored value to the user variable
    });
  }
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/logout'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Successful logout on the server
        prefs.remove('token'); 
         prefs.remove('user'); 
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/', // Route name for your login page
          (Route<dynamic> route) =>
              false, // Remove all routes except the login page
        );
      } else {
        // Handle logout error
        print('Logout failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle logout error
      print('Logout failed. Exception: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return  Drawer(
      child: ListView(children: [
        UserAccountsDrawerHeader(
          
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 213, 199, 153),
          ),
          accountName: Text(user["name"]),
          accountEmail: Text(user["email"]),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(child: Image.asset("images/GM-SOFT.jpg")),
          ),
        ),
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              final categories = categoryProvider.categories;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return ListTile(
                    title: Text(category==""?"All":category),
                    onTap: () {
                      categoryProvider.selectCategory(category==""?"":category);
                      Navigator.pop(context); // Close the sidebar
                    },
                  );
                },
              );
            },
          ),
            
            ListTile(
            leading: Icon(Icons.exit_to_app_outlined),
            title: Text("logout"),
            onTap: () {
              _logout(context);
            }),

            
      ]),
    );
  }
}