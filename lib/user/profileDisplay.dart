import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


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
        Text("Email: ${user?.email}"),
        Text("Phone: ${user?.phoneNumber}"),
        Text("Display Name: ${user?.displayName}"),
        ElevatedButton(onPressed: () {}, child: Text("Edit Profile"))

      ],
    ),
  );
}