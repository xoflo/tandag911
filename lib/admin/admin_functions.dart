import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const.dart';

createEmailUserAdmin(BuildContext context, String email, String password, String department) async {
  final realEmail = '$email@tandagemergencyapp.com';


  await firestore.collection('admins').doc(realEmail).set({
    'email': realEmail,
    'password': password,
    'department': department,
    'created_at': FieldValue.serverTimestamp(),
  });
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: realEmail, password: password);
}