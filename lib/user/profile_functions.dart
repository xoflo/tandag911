import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

editProfile(BuildContext context, User user) {
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController displayName = TextEditingController();

  showDialog(context: context, builder: (_)=> AlertDialog(
    title: Text("Edit Profile"),
    content: Container(
      height: 200,
      width: 300,
      child: Column(
        spacing: 10,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Email'
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Phone'
            ),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Display Name'
            ),
          ),
          Text("Your log-in information will not be changed.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () {
        Navigator.pop(context);
      }, child: Text("Update"))
    ],
  ));
}
