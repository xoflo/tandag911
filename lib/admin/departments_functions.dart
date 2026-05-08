import 'package:flutter/material.dart';
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
      height: 210,
      width: 300,
      child: Column(
        children: [
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