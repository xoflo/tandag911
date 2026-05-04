import 'package:flutter/material.dart';

addDepartmentDialog(BuildContext context) {
  TextEditingController departmentName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  ValueNotifier<bool> visibility = ValueNotifier(true);
  ValueNotifier<bool> usernameInform = ValueNotifier(true);


  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Add Department"),
    content: Container(
      height: 160,
      width: 300,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Department Name'
            ),
          ),
          TextField(
            controller: username,
            decoration: InputDecoration(
              suffixText: '@tandagemergencyapp.com',
                hintText: 'Username'
            ),
            onTap: () {

            },
          ),

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
      TextButton(onPressed: () {

      }, child: Text("Add"))
    ],
  ));
}