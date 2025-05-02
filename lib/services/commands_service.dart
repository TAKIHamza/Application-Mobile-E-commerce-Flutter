import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Command.dart';

class CommandService {
  

  Future<List<Command>> fetchCommands() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getCombinedData'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Command> commands = [];

      for (var commandJson in jsonData["data"]) {
        commands.add(Command.fromJson(commandJson));
      }

      return commands;
    } else {
      print( response.statusCode );
      return [];
      // throw Exception('Failed to fetch Commands');
    }
  }

  Future<List<Command>> fetchClientCommands() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getClientCommands'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Command> commands = [];

      for (var commandJson in jsonData["data"]) {
        commands.add(Command.fromJson(commandJson));
      }

      return commands;
    } else {
      print( response.statusCode );
      return [];
      // throw Exception('Failed to fetch Commands');
    }
  }
}
