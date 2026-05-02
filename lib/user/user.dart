import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/login/login_functions.dart';
import 'package:tandag_911/ui_const.dart';
import 'package:tandag_911/user/homeDisplay.dart';
import 'package:tandag_911/user/profileDisplay.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key, required this.user});

  final User? user;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {


  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (BuildContext context, int value, Widget? child) => Scaffold(
        floatingActionButton: currentIndex.value == 1 ? null : FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {


            }),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              currentIndex.value = value;
            },
            currentIndex: currentIndex.value,
            items: [
              BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home)),
              BottomNavigationBarItem(
                  label: 'Profile',
                  icon: Icon(Icons.supervised_user_circle))
            ]) ,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor,
          title: Text("Tandag Emergency App"),
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
        body: Stack(
          children: [
            Stack(
              children: backgroundWidget(context),
            ),
            ValueListenableBuilder(
                valueListenable: currentIndex,
                builder: (context, value, child) {
                  switch (currentIndex.value) {
                    case 0:
                      return homeDisplay(context);
                    case 1:
                      return profileDisplay(context, widget.user);
                    default:
                      return homeDisplay(context);

                  }})
          ],
        ),
      )
    );

  }

}
