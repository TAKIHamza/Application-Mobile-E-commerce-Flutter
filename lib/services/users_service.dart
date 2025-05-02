import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserService {
  static const String apiUrl = 'http://127.0.0.1:8000/api/users';

  Future<List<User>> fetchUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
   
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<User> users = [];

      for (var userJson in jsonData["users"]) {
        users.add(User.fromJson(userJson));
      }

      return users;
    } else {
      
       throw Exception('Failed to fetch users');
    }
  }
}
