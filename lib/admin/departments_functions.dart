import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../const.dart';
import '../global/app_state.dart';
import 'admin_functions.dart';

addDepartmentDialog(BuildContext context) {
  TextEditingController departmentName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  ValueNotifier<bool> visibility = ValueNotifier(true);
  FocusNode usernameFocus = FocusNode();

  final ImagePicker picker = ImagePicker();
  dynamic image;

  showDialog(context: context, builder: (_) => StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return AlertDialog(
        title: Text("Add Department"),
        content: Container(
          height: 320,
          width: 300,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                child: image == null ? SizedBox() : kIsWeb ? Image.memory(
                    fit: BoxFit.cover,
                    image) : Image.file(
                    fit: BoxFit.cover,
                    image),
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              TextButton(onPressed: () async {

                final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedImage != null) {
                  if (kIsWeb) {
                    image = await pickedImage.readAsBytes();
                  } else {
                    image = File(pickedImage.path);
                  }
                  setState(() {});
                }
              }, child: Text("Add Image")),
              SizedBox(height: 5),
              TextField(
                controller: departmentName,
                decoration: InputDecoration(
                    hintText: 'Department Name'
                ),
              ),
              TextField(
                maxLength: 12,
                controller: username,
                focusNode: usernameFocus,
                decoration: InputDecoration(
                  suffixText: '@tandagemergencyapp.com',
                  hintText: 'Username',
                ),
              ),
              ValueListenableBuilder(valueListenable: username, builder: (z, value, c) {
                if (!usernameFocus.hasFocus || value.text.isEmpty) {
                  return SizedBox();
                }

                return Center(child: Text("${value.text}@tandagemergencyapp.com\nis your login email.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,));
              }),

              ValueListenableBuilder(
                valueListenable: visibility, builder: (BuildContext context, value, Widget? child) {
                return TextField(
                  obscureText: visibility.value,
                  controller: password,
                  decoration: InputDecoration(
                      suffix: IconButton(onPressed: () {
                        visibility.value = !visibility.value;
                      }, icon: Icon(visibility.value ? Icons.visibility : Icons.visibility_off)),
                      hintText: 'Password'
                  ),
                );
              },
              ),

            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () async {
            ignoreAuthChanges = true;

            final ref = storage.ref().child('departments/${DateTime.now()}.jpg');
            await ref.putData(image);

            String downloadUrl = await ref.getDownloadURL();

            await firestore.collection('departments').doc(departmentName.text).set({
                  'name': departmentName.text,
                  'email': username.text,
                  'password': password.text,
                  'image' : downloadUrl
                });

            await createEmailUserAdmin(context, username.text, password.text, departmentName.text);
            ignoreAuthChanges = false;
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Department Added")));
          }, child: Text("Add"))
        ],
      );
    },
  ));
}

deleteDepartmentDialog(BuildContext context, QueryDocumentSnapshot doc) {
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Delete Deparment?"),
    content: Container(
      height: 60,
      width: 120,
      child: Text("This department will be deleted forever."),
    ),
    actions: [
      TextButton(onPressed: () {
        Navigator.pop(context);
      }, child: Text("Cancel")),
      TextButton(onPressed: () async {
        Navigator.pop(context);
        ignoreAuthChanges = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Department Deleted")));

        await doc.reference.delete();
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: doc['email'], password: doc['password']);
        await FirebaseAuth.instance.currentUser!.delete();
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'admin@tandagemergencyapp.com', password: doc['password']);
        ignoreAuthChanges = false;

      }, child: Text("Delete"))
    ],
  ));
}