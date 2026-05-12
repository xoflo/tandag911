import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/admin/settings_functions.dart';
import 'package:tandag_911/user/profile_functions.dart';


profileDisplay(BuildContext context, User? user) {

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      spacing: 10,
      children: [

        Align(
            alignment: Alignment.centerLeft,
            child: Text("Profile", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900))),
        Divider(),
        Text("Email: ${user?.email ?? "N/A"}"),
        Text("Phone: ${user?.phoneNumber}"),
        Text("Display Name: ${user?.displayName}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(onPressed: () {
              editProfile(context, user!);
            }, child: Text("Edit Profile")),

            ElevatedButton(onPressed: () {
              updatePasswordDialog(context, user!);
            }, child: Text("Update Password")),
          ],
        )

      ],
    ),
  );
}