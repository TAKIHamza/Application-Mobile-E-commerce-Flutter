import 'package:flutter/material.dart';


import '../../services/users_service.dart';

class Notification_view extends StatefulWidget {
  const Notification_view({super.key});

  @override
  State<Notification_view> createState() => _Notification_viewState();
}

class _Notification_viewState extends State<Notification_view> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          onPressed: () async {
            UserService userApi = UserService();
            var products = await userApi.fetchUsers();
            for (var e in products) {
              print(e.name);
            }
            
          },
          child: Text("show")),
    );
  }
}
