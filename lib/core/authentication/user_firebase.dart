import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFirebase {
  static Future<String?> signInAnonymously(
      {required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      return userCredential.user?.uid ?? null;
    } on FirebaseAuthException catch (e) {}
  }

  static Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  static Future<bool> isEmailAlreadyUsed(
      {required String email, String password = "wrongPassword"}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "barry.allen@example.com",
              password: "SuperSecretPassword!");
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      } else {
        // if (e.code == 'wrong-password') {
        return true;
      }
    }
  }
}
