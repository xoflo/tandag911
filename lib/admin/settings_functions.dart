import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

updatePasswordDialog(BuildContext context, User user) {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Update Password"),
    content: Container(
      height: 100,
      width: 140,
      child: Column(
        children: [
          TextField(
            controller: oldPass,
            decoration: InputDecoration(
              hintText: 'Old Password',
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
            ),
          ),
          TextField(
            controller: newPass,
            decoration: InputDecoration(
                hintText: 'New Password',
                suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.visibility))
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () async {
        await user.updatePassword(newPass.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Updated")));

      }, child: Text("Update Password"))
    ],
  ));
}


addReportTypeDialog(BuildContext context) {
  TextEditingController reportType = TextEditingController();
  ValueNotifier<int?> codePoint = ValueNotifier(null);

  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Report Type"),
    content: Container(
      height: 160,
      width: 250,
     child: Column(
       children: [
         ValueListenableBuilder(valueListenable: codePoint, builder: (z, value, c) {
           return codePoint.value != null ?
           Icon(
               size: 50,
               IconData(codePoint.value!, fontFamily: 'MaterialIcons')) :
           Container(
             height: 50,
             width: 50,
             color: Colors.grey,
           );

         }),
         SizedBox(height: 10),
         TextButton(onPressed: () async {
           IconPickerIcon? icon = await showIconPicker(
             context,
             configuration: SinglePickerConfiguration(
               iconPackModes: [IconPack.material, IconPack.cupertino],
             ),
           );

           if (icon != null) {
             codePoint.value = icon.data.codePoint;

             print(codePoint);
           }
         }, child: Text("Select Icon")),
         TextField(
           controller: reportType,
           decoration: InputDecoration(
             hintText: 'Report Type'
           ),
         )
       ],
     ), 
    ),
    actions: [
      TextButton(onPressed: () {

      }, child: Text("Add"))
    ],
  ));
}