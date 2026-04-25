import 'package:flutter/material.dart';

import 'login_functions.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ValueNotifier<bool> hidePassword = ValueNotifier<bool>(true);
  ValueNotifier<bool> isPhone = ValueNotifier<bool>(false);

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

                    final isPhone = value.startsWith('+') || RegExp(r'^[0-9]+$').hasMatch(value);
                    this.isPhone.value = isPhone;
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

              ValueListenableBuilder(
                valueListenable: isPhone,
                builder: (context, value, child) => Padding(
                  padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
                  child: ValueListenableBuilder(
                    valueListenable: hidePassword,
                    builder: (context, value, child) => isPhone.value == true ? Text('Phone Authentication is verified via OTP', style: TextStyle(color: Colors.grey)) : TextField(
                      onSubmitted: (value) {
                        signIn(context, username, password);
                      },
                      controller: password,
                      obscureText: value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        labelText: 'Password',
                        hintText: 'Enter your password',
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(onPressed: () async {
                if (isPhone.value == false) {
                  if (username.text.isEmpty || password.text.isEmpty) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
                }


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
