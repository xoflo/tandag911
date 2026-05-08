import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../const.dart';

departmentsDisplay(BuildContext context) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height - 120,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: firestore.collection('admins').snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return snapshot.data!.docs.isEmpty ? Center(child: Text("No Departments Found", style: TextStyle(color: Colors.grey),)) : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: Container(
                        child: Text(snapshot.data!.docs[i]['email']),
                        height: 120,
                      ),
                    );
                  });
            }
        },
        )
      )
    ],
  );
}