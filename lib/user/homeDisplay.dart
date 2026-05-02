import 'package:flutter/material.dart';


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
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, i) {
            return Card(
              child: Container(
                height: 150,
              ),

            );
          }),
        )

      ],
    ),
  );;
}