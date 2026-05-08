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

  ValueNotifier<int?> codePoint = ValueNotifier(null);

  showDialog(context: context, builder: (_) => AlertDialog(
    content: Container(
      height: 300,
      width: 250,
     child: Column(
       children: [
         ValueListenableBuilder(valueListenable: codePoint, builder: (z, value, c) {
           return  codePoint != null ? Icon(IconData(codePoint.value!, fontFamily: 'MaterialIcons')) : Container(),

         })
         SizedBox(height: 10),
         TextButton(onPressed: () async {
           IconPickerIcon? icon = await showIconPicker(
             context,
             configuration: SinglePickerConfiguration(
               iconPackModes: [IconPack.material, IconPack.cupertino],
             ),
           );

           if (icon != null) {
             codePoint = icon.data.codePoint;

             print(codePoint);
           }
         }, child: Text("Select Icon"))
       ],
     ), 
    ),
  ));
}