import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/commands_service.dart';

class Commands_view_admin extends StatefulWidget {
  const Commands_view_admin({super.key});

  @override
  State<Commands_view_admin> createState() => _Commands_view_adminState();
}

class _Commands_view_adminState extends State<Commands_view_admin> {
  CommandService commandService = CommandService();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> changeValidate(int id, int validate) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/updateCommandValidation');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _getToken()}',
    };
    print(id);
    final commandId = {
      'id': id,
      'validation': validate,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(commandId),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Validated successfully .')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red, content: Text('Error Validate .')),
      );
      print('Error changing role user. ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: commandService.fetchCommands(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var commands = snapshot.data;

          return ListView.builder(
            itemCount: commands.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25))),
                      builder: (context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  "Command ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.blueGrey[700]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Command Id : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(commands[index].id.toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text("Product name  : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].productTitle),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text("Quantity  : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].quantity.toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Adresse : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].adresse),
                                  ],
                                ),
                                 SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Total price  : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text((commands[index].productPrice*commands[index].quantity).toString()),
                                  ],
                                ),
                                 SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Created at : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].dateCommand),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Client ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.blueGrey[700]),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Client id : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].userId.toString()),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Name : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].userName),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Email : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].email),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Text(" Telephone : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15)),
                                    const SizedBox(width: 10),
                                    Text(commands[index].telephone),
                                  ],
                                ),
                              ],
                            ),
                          ));
                },
                //-----------------------------------------------------------
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            'http://127.0.0.1:8000/storage/product/image/${commands[index].image}',
                            height: 95,
                            width: 90,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 14, 0, 0),
                                child: SizedBox(
                                  width: 130,
                                  child: Text(
                                    commands[index].productTitle,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 14, 0, 0),
                                child: Text(
                                  "Q : ${commands[index].quantity} ",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              changeValidate(commands[index].id,
                                  commands[index].isValidate);
                              setState(() {});
                            },
                            child: Text(
                              commands[index].isValidate == 0
                                  ? "Not validate"
                                  : "Validate",
                              style: TextStyle(
                                  color: commands[index].isValidate == 0
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 15,
                            child: CircleAvatar(
                              backgroundColor: commands[index].received == 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
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
