import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/users_service.dart';
import 'package:http/http.dart' as http;

class Users_view_admin extends StatefulWidget {
  const Users_view_admin({super.key});

  @override
  State<Users_view_admin> createState() => _Users_view_adminState();
}

class _Users_view_adminState extends State<Users_view_admin> {
  
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> deleteUser(int userId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/deleteUser');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };

    final userid = {
      'id': userId,
    };

    final response = await http.delete(
      url,
      headers: headers,
      body: json.encode(userid),
    );
    if (response.statusCode == 200) {
      // User deleted successfully
      print('User deleted successfully.');
    } else {
      // Error deleting user
      print('Error deleting user. ${response.body}');
    }
  }

  Future<void> changeUserRole(int userId, String role) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/changeUserRole');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };

    final userid = {
      'id': userId,
      'role': role,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(userid),
    );
    if (response.statusCode == 200) {
      // User deleted successfully
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('User Role is updated .')),
                      );
      print('User role updated successfully.');
    } else {
      // Error deleting user
       ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('User Role is not updated .')),
                      );
      print('Error changing role user. ${response.body}');
    }
  }

  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: userService.fetchUsers(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<User> users = snapshot.data;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              String selectedRole = users[index].role;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            users[index].name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          DropdownButton<String>(
                            focusColor: Colors.white,
                            value: selectedRole,
                            onChanged: (String? newValue) {
                              if (users[index].role != newValue) {
                                changeUserRole(users[index].id, newValue!);
                              }
                              setState(() {
                                selectedRole = newValue!;
                              });
                            },
                            items:
                                <String>['admin', 'client'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            users[index].email,
                            style: TextStyle(fontSize: 15),
                          ),
                          IconButton(
                              onPressed: () {
                                deleteUser(users[index].id);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.delete_outlined,
                                color: Colors.red,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
