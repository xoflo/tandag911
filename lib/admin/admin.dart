import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tandag_911/admin/departmentsDisplay.dart';
import 'package:tandag_911/admin/reportsDisplay.dart';
import 'package:tandag_911/admin/settingsDisplay.dart';
import 'package:tandag_911/ui_const.dart';

import '../login/login_functions.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key, required this.user});

  final User user;

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
            actions: [
              IconButton(onPressed: () {
                showDialog(context: context, builder: (_) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                        signOut();
                      }, child: Text("Logout")
                      )]));
              }, icon: Icon(Icons.logout))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex.value,
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
        return departmentsDisplay(context);
      case 2:
        return settingsDisplay(context, widget.user);
      default:
        return reportsDisplay(context);
    }
  }
}
