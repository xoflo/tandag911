import 'package:flutter/material.dart';

departmentsDisplay(BuildContext context) {
  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height - 120,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, i) {
          return Card(
            child: Container(
              height: 120,
            ),
          );
        })
      )
    ],
  );
}