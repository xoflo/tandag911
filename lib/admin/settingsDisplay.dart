import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:tandag_911/admin/settings_functions.dart';

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
        TextButton(
          onPressed: () async {
            addReportTypeDialog(context);
          },
          child: Text("Add Type"),
        ),
        Container(
          height: MediaQuery.of(context).size.height * .35,
          child: StreamBuilder(
            stream: null, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(IconData(Icons.landscape.codePoint, fontFamily: 'MaterialIcons')),
                      title: Text("Crime / Theft"),
                      onTap: () {
                        showDialog(context: context, builder: (_) => AlertDialog());
                      },
                    );
                  });
          },
          ),
        )

      ],
    ),
  );
}