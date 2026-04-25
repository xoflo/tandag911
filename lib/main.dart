import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tandag_911/ui_const.dart';
import 'package:tandag_911/user/user.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider(
          '6LdzhccsAAAAABktnm930RfXAW2MmqJmEzAMJETu'),
    );

    runApp( MyApp());
  } catch(e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        fontFamily: 'Roboto'
      ),
      debugShowCheckedModeBanner: false,
      title: 'Tandag Emergency App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && FirebaseAuth.instance.currentUser != null) {
            return UserScreen(user: FirebaseAuth.instance.currentUser); // logged in
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
