import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tandag_911/user/user.dart';

void handleContactInput(String value, TextEditingController controller) {
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
  if (username.text.contains("@")) {
    await signInWithEmailAndPassword(context, username.text, password.text);
  } else {
    String newString = username.text.replaceAll(' ', '');
    print(newString);
    await verifyPhoneNumber(context, newString);
  }
}

createUserWithEmailAndPassword(BuildContext context, String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    await credential.user!.sendEmailVerification();

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The password provided is too weak.')));
    } else if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
    }
  }
}

Future<void> sendResetPassword(BuildContext context, String email) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Reset Email Sent")));
  } on FirebaseAuthException catch (e) {
    print("Error: ${e.code}");
  }
}

signInWithEmailAndPassword(BuildContext context, String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );
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
          content: TextField(
            controller: smsController,
            maxLength: 6,
            keyboardType: TextInputType.number,
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
            height: 300,
            width: 300,
            child: TextField(
              controller: smsController,
              maxLength: 6,
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