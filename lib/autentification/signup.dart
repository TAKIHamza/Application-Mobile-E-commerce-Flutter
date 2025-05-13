import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../public/sharedPreferencesHelper.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

    Future<void> _signup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password' : password,
    };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/signup'), // Replace with your Laravel API URL for signup
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
         final jsonData = jsonDecode(response.body);
        String token = jsonData['token'];
        print(token);
        print(jsonData['user']['role']);
        
       // Save the token to local storage using shared_preferences
        await SharedPreferencesHelper().saveToken(token,jsonEncode(jsonData['user']));
        // If signup is successful, navigate to login page
         Navigator.pushReplacementNamed(context, '/home');
      } else {
        var redirectUrl = response.headers['location'];
    print('Redirect URL: $redirectUrl');
    print(response.statusCode);
        setState(() {
          _errorMessage = 'Failed to sign up. Please try again...';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to sign up. Please try again.';
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
      
      body: SingleChildScrollView(
         physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
      
              SizedBox(height: 100.0),
      
        // ------------------logo------------------------
              Container(
                width: 115,
                height: 115,
              child: Image.asset("images/GM-SOFT.jpg"),
              ),
              SizedBox(height: 20.0),
              
      
           //-------------------message d'erreur ---------------------
             
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
      
          //----------------------- inputs-------------------------------------      
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 18.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                
              ),
              SizedBox(height: 18.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: ' Password'),
              ),
              SizedBox(height: 60.0),
      
          //------------ bouton de signup et de retour à la page login---------        
             Center(
             child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  
                ),
                onPressed: _isLoading ? null : _signup,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Sign up'),
              ),),
              SizedBox(height: 16.0),
              
              // pour le retour à la page de login 
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),backgroundColor: Colors.white,
    );
  }
}

