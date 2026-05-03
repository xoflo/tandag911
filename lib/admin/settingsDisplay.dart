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
          }, child: Text("Update Password")),
        ],
      ),
    ),
  );
}