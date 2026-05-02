import 'package:flutter/material.dart';

reportsDisplay(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text("Open Tasks", style: TextStyle(fontSize: 20)),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width * .31,
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text("Report Title"),
                        );
                      }),
                ),
              ],
            ),

            Column(
              children: [
                Text("Assigned"),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width * .31,
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text("Report Title"),
                        );
                      }),
                ),
              ],
            ),

            Column(
              children: [
                Text("Resolved"),
                Container(
                  height: MediaQuery.of(context).size.height - 200,
                  width: MediaQuery.of(context).size.width * .31,
                  child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text("Report Title"),
                        );
                      }),
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}