import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

settingsDisplay(BuildContext context, User user) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(user.email.toString()),
          ElevatedButton(onPressed: () {
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
          }, child: Text("Update Password")),
        ],
      ),
    ),
  );
}