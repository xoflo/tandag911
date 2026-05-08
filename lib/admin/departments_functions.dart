import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/const.dart';
import 'admin_functions.dart';

addDepartmentDialog(BuildContext context) {
  TextEditingController departmentName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  ValueNotifier<bool> visibility = ValueNotifier(true);
  FocusNode usernameFocus = FocusNode();


  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Department"),
    content: Container(
      height: 345,
      width: 300,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 5),
          TextButton(onPressed: () {}, child: Text("Add Image")),
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
        await createEmailUserAdmin(context, username.text, password.text, departmentName.text);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Department Added")));
      }, child: Text("Add"))
    ],
  ));
}

deleteDepartmentDialog(BuildContext context, QueryDocumentSnapshot doc) {
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Delete Deparment?"),
    content: Container(
      height: 60,
      width: 120,
      child: Text("This department will be deleted forever. Go to account settings and delete?"),
    ),
    actions: [
      TextButton(onPressed: () {
        Navigator.pop(context);
      }, child: Text("Cancel")),
      TextButton(onPressed: () async {
        ignoreAuthChanges = true;
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: doc['email'], password: doc['password']);
        await FirebaseAuth.instance.currentUser!.delete();
        await doc.reference.delete();
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: 'admin@tandagemergencyapp.com', password: doc['password']);
        ignoreAuthChanges = false;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Department Deleted")));

      }, child: Text("Delete"))
    ],
  ));
}