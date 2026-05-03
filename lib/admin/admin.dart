import 'package:flutter/material.dart';
import 'package:tandag_911/admin/reportsDisplay.dart';
import 'package:tandag_911/ui_const.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key, required this.user});

  final String user;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex, builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text("Tandag Emergency App", style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              currentIndex.value = value;
            },
              items: [
                BottomNavigationBarItem(
                    label: 'Reports',
                    icon: Icon(Icons.assignment_ind)),
                BottomNavigationBarItem(
                    label: 'Departments',
                    icon: Icon(Icons.list)),
                BottomNavigationBarItem(
                    label: 'Settings',
                    icon: Icon(Icons.settings)),
              ]),
          body: screenHandler(value),

        );
    },
    );
  }

  screenHandler(int value) {
    switch(value) {
      case 0:
        return reportsDisplay(context);
      case 1:
        return Text("Departments");
      case 2:
        return Text("Settings");
      default:
        return Text("Tasks");
    }
  }
}
