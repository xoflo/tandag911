import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tandag_911/ui_const.dart';

reportsDisplay(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(22),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MediaQuery.of(context).size.width > 500 ? Row(
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
                          onTap: () {
                            showDialog(context: context, builder: (_) => AlertDialog(
                              content: Container(
                                height: 200,
                                width: 200,
                              ),
                            ));
                          },
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
        ) : Column(
          children: [
            Builder(
              builder: (context) {
                ValueNotifier<int> selectCategory = ValueNotifier(0);
                List<String> categories = ['Open Tasks', 'Assigned', 'Resolved'];
                int lastIndex = 0;

                return ValueListenableBuilder(
                  valueListenable: selectCategory, builder: (BuildContext context, value, Widget? child) {
                    return selectCategory.value > -1 && selectCategory.value < 3 ? Align(
                      alignment: Alignment.centerLeft,
                      child: Card(child: TextButton(onPressed: () {
                        lastIndex = selectCategory.value;
                        selectCategory.value = 4;
                      }, child: Text(categories[selectCategory.value]).animate().fadeIn())),
                    ) : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(onPressed: () {
                            selectCategory.value = 0;
                          }, child: Text("Open Tasks", style: TextStyle(color: lastIndex == 0 ? primaryColor : Colors.grey))),
                          TextButton(onPressed: () {
                            selectCategory.value = 1;
                          }, child: Text("Assigned", style: TextStyle(color: lastIndex == 1 ? primaryColor : Colors.grey))),
                          TextButton(onPressed: () {
                            selectCategory.value = 2;
                          }, child: Text("Resolved", style: TextStyle(color: lastIndex == 2 ? primaryColor : Colors.grey))),
                        ],
                      ).animate().fadeIn(),
                    );
                });

              }
            ),
            Container(
              padding: EdgeInsets.all(12),
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, i) {
                    return ListTile(
                      onTap: () {
                        showDialog(context: context, builder: (_) => AlertDialog(
                          content: Container(
                            height: 200,
                            width: 200,
                          ),
                        ));
                      },
                      title: Text("Report Title"),
                    );
                  }),
            ),

            ],)
      ],
    ),
  );
}