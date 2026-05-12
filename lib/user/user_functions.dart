import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';

addReport(BuildContext context, User user) {
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Report"),
    content: Container(
      height: 300,
      width: 300,
      child: Column(
        spacing: 10,
        children: [
          ListTile(
            title: Text('Report Type: Select'),
            onTap: () {},
          ),
          TextField(
            maxLength: 20,
            decoration: InputDecoration(
              hintText: 'Title'
            ),
          ),
          TextField(
            maxLength: 300,
            maxLines: 5,
            decoration: InputDecoration(
                hintText: 'Description'
            ),
          ),

        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () {}, child: Text("Add Report"))
    ],
  ));
}

submitReport(BuildContext context, User user, String title, String description, String type) async {
  await firestore.collection('reports').add({
    'email': user.email,
    'phone': user.phoneNumber,
    'displayName': user.displayName,
    'createdAt': FieldValue.serverTimestamp(),
    'status': 'Pending',
    'type': type,
    'title': title,
    'description': description
  });

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Report Submitted")));
}

selectType(BuildContext context) {
  showDialog(context: context, builder: (_) => AlertDialog(
    content: Container(

    ),
  ));
}
