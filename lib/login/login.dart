import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Container(
              height: 250,
              width: 250,
              child: Image.asset('tandagLogo.png')),
          Text("Tandag Emergency App", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),),
          Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 0, 36.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
                labelText: 'Username / Email',
                hintText: 'Enter your username',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(36.0, 0, 36.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
            ),
          ),


        ],
      ),
    );
  }
}
