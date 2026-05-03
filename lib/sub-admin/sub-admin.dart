import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../login/login_functions.dart';

class SubAdminScreen extends StatefulWidget {
  const SubAdminScreen({super.key, required this.user});

  final User user;

  @override
  State<SubAdminScreen> createState() => _SubAdminScreenState();
}

class _SubAdminScreenState extends State<SubAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tandag Emergency App"), actions: [
        IconButton(onPressed: () {
          showDialog(context: context, builder: (_) => AlertDialog(
              title: Text("Logout"),
              content: Text("Are you sure you want to logout?"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.pop(context);
                  signOut();
                }, child: Text("Logout")
                )]));
        }, icon: Icon(Icons.logout))
      ],),
      body: Column(
        children: [],
      ),
    );
  }
}
