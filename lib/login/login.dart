import 'package:flutter/material.dart';

import 'login_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  ValueNotifier<bool> hidePassword = ValueNotifier<bool>(true);

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

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
            padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
            child: TextField(
              controller: username,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
                labelText: 'Phone Number / Email',
                hintText: 'Phone Number / Email',
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
            child: ValueListenableBuilder(
              valueListenable: hidePassword,
              builder: (context, value, child) =>
              TextField(
                controller: password,
                obscureText: value,
                decoration: InputDecoration(

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
            ),
          ),

          IconButton(onPressed: () {
            hidePassword.value = !hidePassword.value;
          }, icon: Icon(hidePassword.value ? Icons.visibility : Icons.visibility_off)),

          ElevatedButton(onPressed: () {
            if (username.text.contains("@")) {
              signInWithEmailAndPassword(username.text, password.text);
            } else {
              verifyPhoneNumber(context, username.text);
            }
          }, child: Container(

              child: Text("Sign-In"))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(onPressed: () {}, child: Text("Forget Password")),
              TextButton(onPressed: () {}, child: Text("Sign-Up")),
            ],
          )


        ],
      ),
    );
  }
}
