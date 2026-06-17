import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/admin/departments_functions.dart';

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
                    return InkWell(
                      onLongPress: () async {
                        deleteDepartmentDialog(context, snapshot.data!.docs[i]);
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                child: Image.network(snapshot.data!.docs[i]['image']),
                              ),
                              Column(children: [

                              ],)
                            ],
                          ),
                          height: 120,
                        ),
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