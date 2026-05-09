import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:tandag_911/admin/settings_functions.dart';

import '../const.dart';

settingsDisplay(BuildContext context, User user) {
  return Padding(
    padding: EdgeInsets.all(22),
    child: Column(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft,child: Text("Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),)),
        Text(user.email.toString()),
        ElevatedButton(onPressed: () {
          updatePasswordDialog(context, user);
        }, child: Text("Update Password")),
        Divider(),
        Align(alignment: Alignment.centerLeft,child: Text("Report Types", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),)),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () async {
              addReportTypeDialog(context);
            },
            child: Text("+ Add Type"),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height - 400,
          child: StreamBuilder(
            stream: firestore.collection('reportTypes').orderBy('createdAt').snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  )
                );
              } else {
                return snapshot.data!.docs.isEmpty ? Center(child: Text("No Report Types", style: TextStyle(color: Colors.grey),)) : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        leading: Icon(IconData(snapshot.data!.docs[i].get('codePoint'), fontFamily: 'MaterialIcons')),
                        title: Text(snapshot.data!.docs[i].get('name')),
                        onLongPress: () {
                          showDialog(context: context, builder: (_) => AlertDialog(
                            title: Text("Delete Report Type?"),
                            actions: [
                              TextButton(onPressed: () async {
                                await snapshot.data!.docs[i].reference.delete();
                              }, child: Text("Delete"))
                            ],
                          ));
                        },
                      );
                    });
              }


          },
          ),
        )

      ],
    ),
  );
}