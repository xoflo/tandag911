import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/login/login_functions.dart';
import 'package:tandag_911/ui_const.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key, required this.user});

  final User? user;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {}),
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                label: 'Recent Reports',
                icon: Icon(Icons.feed)),
            BottomNavigationBarItem(
                label: 'Profile',
                icon: Icon(Icons.supervised_user_circle))
      ]),
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
          Container(
            child: Image.asset('background.jpg', fit: BoxFit.cover),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: Opacity(
              opacity: .2,
              child: Container(
                child: Image.asset('tandagLogo.png'),
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.user!.email.toString()),
              Text(widget.user!.phoneNumber.toString())
            ],
          )
        ],
      ),
    );
  }
}
