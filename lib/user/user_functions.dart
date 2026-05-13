
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../const.dart';

addReport(BuildContext context, User user) {
  ValueNotifier<String?> type = ValueNotifier(null);
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();


  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Report"),
    content: Container(
      height: 300,
      width: 300,
      child: Column(
        spacing: 10,
        children: [
          ValueListenableBuilder(
            valueListenable: type, builder: (BuildContext context, value, Widget? child) {
              return ListTile(
                leading: type.value != null ? Icon(IconData(int.parse(type.value!.split("_")[1]), fontFamily: 'MaterialIcons')) : null,
                title: Text('${type.value?.split("_")[0] ?? 'Report Type: Select'}'),
                onTap: () async {
                  final result = await selectType(context);
                  print(result.toString());
                  type.value = result.toString();
                },
              );
            },
          ),
          TextField(
            controller: title,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: 'Title'
            ),
          ),
          TextField(
            controller: description,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(
                hintText: 'Description'
            ),
          ),
          TextButton(onPressed: () {
            pickMediaFiles();
          }, child: Text("Add Attachments"),)

        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () {
        submitReport(context, user, title.text.trim(), description.text.trim(), type.value!.trim());
      }, child: Text("Add Report"))
    ],
  ));
}


Future<FilePickerResult?> pickMediaFiles() async {

  Future<void> pickFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles();

    if (result != null) {
      print(result.files.single.name);
    }
  }

}

submitReport(BuildContext context, User user, String title, String description, String type) async {
  if (type.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a report type."))
    );
    return;
  }

  if (title.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a title."))
    );
    return;
  }

  if (description.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a description."))
    );
    return;
  }

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
  return showDialog(context: context, builder: (_) => AlertDialog(
    content: Container(
      height: 300,
      width: 300,
      child: StreamBuilder(stream: firestore.collection('reportTypes').snapshots(), builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }

        return snapshot.data!.docs.isEmpty ? Center(child: Text(
            "No Report Types", style: TextStyle(color: Colors.grey))) : ListView
            .builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: Icon(IconData(snapshot.data!.docs[i].get('codePoint'), fontFamily: 'MaterialIcons')),
                title: Text(snapshot.data!.docs[i].get('name')),
                onTap: () {
                  final typeValue = "${snapshot.data!.docs[i].get('name')}_${snapshot.data!.docs[i].get('codePoint')}";
                  Navigator.pop(context, typeValue);

                },
              );

            });


      }
    ),
  )));
}
