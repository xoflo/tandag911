import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../const.dart';

createEmailUserAdmin(BuildContext context, String email, String password, String department) async {
  await firestore.collection('admins').add({
    'email': '$email@tandagemergencyapp.com',
    'password': password,
    'department': department,
    'created_at': FieldValue.serverTimestamp(),
  });
  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
}