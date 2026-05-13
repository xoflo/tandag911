import 'package:flutter/material.dart';
import 'package:tandag_911/login/signup.dart';

import 'login_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 15,
            children: [
              Container(
                  height: 250,
                  width: 250,
                  child: Image.asset('tandagLogo.png')),
              Text(
                "Tandag Emergency App",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(42.0, 0, 42.0, 0),
                child: TextField(
                  onSubmitted: (value) {
                    signIn(context, username, password);
                  },
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
              ValueListenableBuilder(
                valueListenable: isPhone, builder: (BuildContext context, value, Widget? child) {
                  return  ValueListenableBuilder(
                    valueListenable: hidePassword,
                    builder: (BuildContext context, bool value, Widget? child) {
                      return IconButton(
                          onPressed: () {
                            hidePassword.value = !hidePassword.value;
                          },
                          icon: Icon(hidePassword.value
                              ? Icons.visibility
                              : Icons.visibility_off));
                    },
                  );
              },
              ),

              ElevatedButton(
                  onPressed: () async {
                    if (isPhone.value == false) {
                      if (username.text.isEmpty || password.text.isEmpty) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
                    }

                    signIn(context, username, password);
                  },
                  child: Container(child: Text("Sign-In"))),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        TextEditingController resetUsername = TextEditingController();

                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(

                                title: Text("Reset Password"),
                                content: Container(
                                    height: 60,
                                    width: 300,
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: resetUsername,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            labelText: 'Email',
                                            hintText:
                                                'Email Accounts Only',
                                          ),
                                          onChanged: (value) {
                                            handleUsernameInput(value, resetUsername);
                                          },
                                          onSubmitted: (value) {
                                            Navigator.pop(context);
                                            sendResetPassword(context, resetUsername.text);
                                          },
                                        ),

                                      ],
                                    )
                                ),
                              actions: [
                                TextButton(onPressed: () {
                                  sendResetPassword(context, resetUsername.text);
                                }, child: Text("Reset Password"))
                              ],
                            ));
                      },
                      child: Text("Reset Password")),


                  TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignupScreen()));
                      },
                      child: Text("Sign-Up")),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
