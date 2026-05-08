import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/admin/settings_functions.dart';

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
            updatePasswordDialog(context, user);
          }, child: Text("Update Password")),
        ],
      ),
    ),
  );
}