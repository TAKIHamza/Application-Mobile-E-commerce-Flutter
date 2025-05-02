import 'package:flutter/material.dart';

import 'package:flutter_dev/Provider/cart_provider.dart';
import 'package:flutter_dev/Provider/favorite_provider.dart';
import 'package:flutter_dev/admin/home_page_admin.dart';
import 'package:flutter_dev/public/sharedPreferencesHelper.dart';
import 'package:flutter_dev/autentification/login.dart';
import 'package:flutter_dev/autentification/signup.dart';
import 'package:flutter_dev/user/views/cart.dart';
import 'package:flutter_dev/user/views/homepage.dart';
import 'package:provider/provider.dart';

import 'Provider/catigory_provider.dart';
import 'Provider/themeProvider.dart';
import 'admin/addProduct.dart';


void main() 
async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesHelper().initialize();
   
runApp(
   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Favorites()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(ThemeData(primarySwatch: Colors.blue),Colors.blue))
      ],
      child: const MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GM-SOFT App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(), 
        '/home/cart': (context) => CartPage(), 
         '/adminHome': (context) => Home_page_admin(),
         '/adminHome/addProduct': (context) => AddProductPage(),
      },
    );
  }
}

