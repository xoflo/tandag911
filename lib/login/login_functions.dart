import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


createUserWithEmailAndPassword(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }
}

signInWithEmailAndPassword(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

signOut() async {
  await FirebaseAuth.instance.signOut();
}


verifyPhoneNumber(BuildContext context, String phoneNumber, {int? resendToken}) async {
  FirebaseAuth auth = FirebaseAuth.instance;


  if (kIsWeb) {

    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber('+63 $phoneNumber');
    TextEditingController smsController = TextEditingController();

    showDialog(context: context, builder: (_) => AlertDialog(
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

      UserCredential userCredential = await confirmationResult.confirm(smsController.text);
    }, child: Text("Submit"))
      ],
    )).then((value) {
      smsController.dispose();
    });

  }

  if (TargetPlatform.android == defaultTargetPlatform) {
    await auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      forceResendingToken: resendToken,
      phoneNumber: '+63 $phoneNumber',
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
                await auth.signInWithCredential(credential);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign-in Successful.")));

              } catch(e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }, child: Text("Submit"))
          ],
        )).then((value) {
          smsController.dispose();
        });

      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request Timeout")));
      },
    );
  }

}