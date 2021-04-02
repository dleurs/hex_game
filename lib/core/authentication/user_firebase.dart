import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserFirebase {
  static Future<String?> signInAnonymously(
      {required BuildContext context}) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return userCredential.user?.uid ?? null;
  }
}
