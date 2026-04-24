import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/login/login_functions.dart';
import 'package:tandag_911/ui_const.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key, required this.user});

  final User? user;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        title: Text("Tandag Emergency App"),
        actions: [
          IconButton(onPressed: () {
            signOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.user!.email.toString()),
          Text(widget.user!.phoneNumber.toString())
        ],
      ),
    );
  }
}
