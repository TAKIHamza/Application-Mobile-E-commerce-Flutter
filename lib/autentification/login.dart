import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../public/sharedPreferencesHelper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'http://127.0.0.1:8000/api/login'), // Replace with your Laravel API URL
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Si la connexion est réussie, accédez à la page home
        final jsonData = jsonDecode(response.body);
        String token = jsonData['token'];
        print(token);
        print(jsonData['user']['role']);
        
       // Save the token to local storage using shared_preferences
        await SharedPreferencesHelper().saveToken(token,jsonEncode(jsonData['user']));
           print(jsonData['user']['role']);
        if (jsonData['user']['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/adminHome');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to login. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        
        child: Container(
          
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 100,
              ),
      
              // logo
              Container(
                width: 120,
                height: 120,
                child: Image.asset("images/GM-SOFT.jpg"),
              ),
      
              SizedBox(height: 40.0),
      
              // message d'erreur
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0),
      
              // les inputs
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 22.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 100.0),
      
              // button de login
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? CircularProgressIndicator() : Text('Login'),
                ),
              ),
              SizedBox(height: 16.0),
      
              // button pour naviger à la page de signup
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Sign up'),
              ),
              //-----------------------------
              SizedBox(height: 16.0),
      
            ],
          ),
        ),
      ),backgroundColor: Colors.white,
    );
  }
}
