import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

updatePasswordDialog(BuildContext context, User user) {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Update Password"),
    content: Container(
      height: 300,
      width: 300,
      child: Column(
        children: [
          TextField(
            controller: oldPass,
            decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
            ),
          ),
          TextField(
            controller: newPass,
            decoration: InputDecoration(
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () async {
        await user.updatePassword(newPass.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Updated")));

      }, child: Text("Update Password"))
    ],
  ));
}