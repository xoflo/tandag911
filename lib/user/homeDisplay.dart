import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../const.dart';

homeDisplay(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      spacing: 5,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text("Home", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900))),
        Divider(),
        Align(alignment: Alignment.centerLeft ,child: Text("Recent Reports", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),)),
        Container(
          height: MediaQuery.of(context).size.height - 300,
          width: MediaQuery.of(context).size.width - 30,
          child: StreamBuilder(
            stream: firestore.collection('reports').snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return snapshot.data!.docs.length == 0 ? Center(child: Text("No Reports", style: TextStyle(color: Colors.grey))) : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Container(
                      height: 150,
                    ),
                  );
                });
          },
          ),
        )
      ],
    ),
  );;
}