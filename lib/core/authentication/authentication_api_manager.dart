import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class AuthenticationApiProvider {
  //ArtemisClient get _client => ArtemisClient(Config.authApiEndpoint);
  var db = FirebaseAuth.instance;

  Future<String?> loginAnonymously({required BuildContext context}) async {
    try {
      UserCredential userCredential = await db.signInAnonymously();
      return userCredential.user?.uid ?? null;
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await db.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> logout() {
    return Future.value();
  }
}
