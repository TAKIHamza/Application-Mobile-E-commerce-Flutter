import 'package:flutter/material.dart';
import 'package:flutter_dev/admin/addProduct.dart';
import 'package:flutter_dev/admin/users_view_admin.dart';
import 'package:flutter_dev/admin/changeTheme.dart';
import 'package:flutter_dev/admin/products_view_admin.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../../Provider/themeProvider.dart';
import '../widgets/sidebar.dart';
import 'commands_view_admin.dart';

class Home_page_admin extends StatefulWidget {
  const Home_page_admin({super.key});

  @override
  State<Home_page_admin> createState() => _Home_page_adminState();
}

int currentPage = 2;

class _Home_page_adminState extends State<Home_page_admin> {
  final liste = <Widget>[
    Users_view_admin(),
    AddProductPage(),
    Products_view_admin(),
    Commands_view_admin(),
    ChangeTheme()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const SideBar(),
      extendBody: true,
      body: liste[currentPage],
      bottomNavigationBar: CurvedNavigationBar(
        items: [
          Icon(Icons.people_alt_outlined, color: Colors.white),
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.comment_bank_rounded, color: Colors.white),
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
