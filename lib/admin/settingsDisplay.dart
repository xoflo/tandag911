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
            showDialog(context: context, builder: (_) => AlertDialog(
              title: Text("Update Password"),
              content: Container(
                height: 300,
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
                      ),
                    ),
                    TextField(),
                  ],
                ),
              ),
            ));
          }, child: Text("Update Password")),
        ],
      ),
    ),
  );
}