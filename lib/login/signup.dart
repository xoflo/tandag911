import 'package:flutter/material.dart';

import 'login_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ValueNotifier<bool> hidePassword = ValueNotifier<bool>(true);

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.asset('background.jpg', fit: BoxFit.cover),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 50,
              width: 50,
              child: IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.chevron_left)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Container(
                  height: 250,
                  width: 250,
                  child: Image.asset('tandagLogo.png')),
              Text("Tandag Emergency App", style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),),
              Text("Sign-Up", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
              Padding(
                padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
                child: TextField(
                  onChanged: (value) {
                    handleUsernameInput(value, username);
                  },
                  controller: username,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: 'Phone Number / Email',
                    hintText: '+63 (Insert Number) / Email',
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
              ValueListenableBuilder(
                valueListenable: hidePassword,
                builder: (BuildContext context, bool value, Widget? child) {
                  return IconButton(onPressed: () {
                    hidePassword.value = !hidePassword.value;
                  }, icon: Icon(hidePassword.value ? Icons.visibility : Icons.visibility_off));
                },
              ),

              ElevatedButton(onPressed: () async {
                if (username.text.contains("@")) {
                  createUserWithEmailAndPassword(context, username.text, password.text);
                } else {
                  String newString = username.text.replaceAll(' ', '');
                  print(newString);
                  await verifyPhoneNumber(context, newString);
                }
               }, child: Text("Create Account"))


            ],
          )
        ],
      ),
    );
  }
}
