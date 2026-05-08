import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/admin/admin.dart';
import 'package:tandag_911/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tandag_911/sub-admin/sub-admin.dart';
import 'package:tandag_911/ui_const.dart';
import 'package:tandag_911/user/user.dart';
import 'const.dart';
import 'firebase_options.dart';
import 'global/app_state.dart';
import 'login/signup.dart';

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
        stream: ignoreAuthChanges == true ? null : FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && FirebaseAuth.instance.currentUser != null) {
            if (FirebaseAuth.instance.currentUser!.email != null) {
              if (FirebaseAuth.instance.currentUser!.email!.contains('tandagemergencyapp.com')) {
                final user = FirebaseAuth.instance.currentUser!.email!.split('@')[0];

                if (user.contains('admin') && user.length == 5) {
                  return AdminScreen(user: FirebaseAuth.instance.currentUser!);
                } else {
                  return SubAdminScreen(user: FirebaseAuth.instance.currentUser!);
                }
              }
            }

            return UserScreen(user: FirebaseAuth.instance.currentUser); // logged in

          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
