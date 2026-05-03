import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/admin/admin.dart';
import 'package:tandag_911/user/user.dart';

import '../const.dart';
import '../sub-admin/sub-admin.dart';

void handleUsernameInput(String value, TextEditingController controller) {
  final trimmed = value.replaceAll(' ', '');

  if (trimmed.isEmpty) return;

  // email → don't touch
  if (RegExp(r'[a-zA-Z@]').hasMatch(trimmed)) return;

  // allow "+"
  if (trimmed.startsWith('+') && !trimmed.startsWith('+63')) return;

  String digits = trimmed;

  // normalize to 63XXXXXXXXXX
  if (RegExp(r'^[0-9]+$').hasMatch(trimmed)) {
    if (trimmed.startsWith('0')) {
      digits = '63${trimmed.substring(1)}';
    } else if (!trimmed.startsWith('63')) {
      digits = '63$trimmed';
    }
  } else if (trimmed.startsWith('+63')) {
    digits = trimmed.substring(1);
  }

  // apply 3-3-4 spacing
  if (digits.startsWith('63')) {
    String rest = digits.substring(2);

    String part1 = rest.length > 3 ? rest.substring(0, 3) : rest;
    String part2 = rest.length > 3
        ? (rest.length > 6 ? rest.substring(3, 6) : rest.substring(3))
        : '';
    String part3 = rest.length > 6 ? rest.substring(6) : '';

    String formatted = '+63';
    if (part1.isNotEmpty) formatted += ' $part1';
    if (part2.isNotEmpty) formatted += ' $part2';
    if (part3.isNotEmpty) formatted += ' $part3';

    if (formatted != value) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }
}

void signIn(BuildContext context, TextEditingController username, TextEditingController password) async {

  if (username.text.contains('tandagemergencyapp.com')) {

    final user = username.text.split('@')[0];

    if (user != 'admin') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => SubAdminScreen(user: user)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen(user: user)));
    }

    return;
  }

  if (username.text.contains("@")) {
    await signInWithEmailAndPassword(context, username.text, password.text);
  } else {
    String newString = username.text.replaceAll(' ', '');
    print(newString);
    await verifyPhoneNumber(context, newString);
  }
}

returnToLogin(BuildContext context) {
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/login',
        (route) => false,
  );
}

createUserWithEmailAndPassword(BuildContext context, String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    await credential.user!.sendEmailVerification();

    Navigator.pop(context);
    verifyEmailPrompt(context);

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
    }
  }
}

Future<void> sendResetPassword(BuildContext context, String username) async {
  try {
    if (username.contains('@')) {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: username.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reset Email Sent")));
    } else {
      Navigator.pop(context);
      String newString = username.replaceAll(' ', '');
      await verifyPhoneNumber(context, newString);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password updated")));
    }


  } on FirebaseAuthException catch (e) {
    print("Error: ${e.code}");
  }
}

verifyEmailPrompt(BuildContext context) {
  showDialog(context: context, builder: (_) => AlertDialog(
    title: Text("Email Verification Sent"),
    content: Container(
      height: 140,
      width: 300,
      child: Column(
        spacing: 5,
        children: [
          Icon(
              size: 30,
              Icons.mark_email_unread_outlined),
          Text("Your account is already created", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          Text("To complete your sign-up, verify your email by clicking the link sent to your email (all inbox or spam). After verification, you will be able to log-in to the app. Signing in without verification will trigger another verification link.", textAlign: TextAlign.center)
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () {
        Navigator.pop(context);
      }, child: Text("I Understand")),
    ],
  ));
}

signInWithEmailAndPassword(BuildContext context, String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );

    if (credential.user!.emailVerified == false) {
      verifyEmailPrompt(context);
    } else {
      credential.user!.reload();
    }
  } on FirebaseAuthException catch (e) {
    print(e.code);
    if (e.code == 'missing-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No password provided for that user.')));
    } else if (e.code == 'invalid-credential') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email and password do not match.')));
    }
  }
}

signOut() async {
  await FirebaseAuth.instance.signOut();
}


verifyPhoneNumber(BuildContext context, String phoneNumber, {int? resendToken}) async {
  FirebaseAuth auth = FirebaseAuth.instance;


  if (kIsWeb) {
    try {
      final confirmationResult =
      await auth.signInWithPhoneNumber(phoneNumber);

      final smsController = TextEditingController();

      if (!context.mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Enter OTP"),
          content: Container(
            height: 160,
            width: 300,
            child: Column(
              spacing: 10,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter SMS Code'
                  ),
                  controller: smsController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),

                Icon(
                    size: 30,
                    Icons.phone_iphone),
                Text("An OTP has been sent to your phone number. Please wait for a minute before trying again.", textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final UserCredential userCredential =
                  await confirmationResult.confirm(
                    smsController.text.trim(),
                  );


                  if (!context.mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Sign-in Successful.")),
                  );


                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid OTP / Error")),
                  );
                }
              },
              child: Text("Submit"),
            )
          ],
        ),
      );

      smsController.dispose();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number')
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid Phone Number")),
      );
    }
  }

  if (TargetPlatform.android == defaultTargetPlatform) {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      phoneNumber: '$phoneNumber',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {

        TextEditingController smsController = TextEditingController();

        showDialog(context: context, builder: (_) => AlertDialog(
          title: Text("Enter SMS Code"),
          content: Container(
            height: 120,
            width: 300,
            child: Column(
              spacing: 10,
              children: [
                TextField(
                  decoration: InputDecoration(
                      hintText: 'Enter SMS Code'
                  ),
                  controller: smsController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
                Text("An OTP has been sent to your phone number.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () async {
              smsController.clear();
              verifyPhoneNumber(context, phoneNumber, resendToken: resendToken);
            }, child: Text("Resend Code")),
            TextButton(onPressed: () async {
              try {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsController.text);
                final userCredential = await auth.signInWithCredential(credential);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-in Successful.")));


              } catch(e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }, child: Text("Submit"))
          ],
        ));

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request Timeout")));
      },
    );
  }

}