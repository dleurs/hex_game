import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/firebase_user_storage.dart';

class Player extends ChangeNotifier {
  String? uid;
  bool isAnonymous;
  String? pseudo;
  String? email;
  bool optInNewsletter;
  Player(
      {this.uid,
      this.isAnonymous = false,
      this.pseudo,
      this.email,
      this.optInNewsletter = false});

  static const String uidArg = "uid";
  static const String isAnonymousArg = "isAnonymous";
  static const String pseudoArg = "pseudo";
  static const String emailArg = "email";
  static const String dateRegisterEmailArg = "dateRegisterEmail";
  static const String dateRegisterAnonymousArg = "dateRegisterAnonymous";
  static const String dateLastUpdateArg = "dateLastUpdate";
  static const String optInNewsletterArg = "optInNewsletter";

  bool isLoggedIn() {
    return (uid != null);
  }

  void updateFirebase(User? firebaseUser) async {
    if (firebaseUser == null) {
      return;
    }
    Player? updatedPlayer =
        await FirestoreUserStorage.getPlayer(uid: firebaseUser.uid);
    if (updatedPlayer == null) {
      return null;
    }
    update(updatedPlayer);
  }

  void update(Player updatedPlayer) {
    uid = updatedPlayer.uid;
    isAnonymous = updatedPlayer.isAnonymous;
    pseudo = updatedPlayer.pseudo;
    email = updatedPlayer.email;
    optInNewsletter = updatedPlayer.optInNewsletter;
    notifyListeners();
  }

  @override
  String toString() {
    return 'Player{$uidArg: $uid, $isAnonymousArg: $isAnonymous, $pseudoArg: $pseudo, $emailArg: $email}';
  }

  Map<String, dynamic> toFirebase({required SaveFirestoreOperation operation}) {
    Map<String, dynamic> mapToFirebase = {
      uidArg: uid,
      isAnonymousArg: isAnonymous,
      pseudoArg: pseudo,
      emailArg: email,
      optInNewsletterArg: optInNewsletter,
      dateLastUpdateArg: DateTime.now()
    };
    if (operation == SaveFirestoreOperation.emailRegister) {
      mapToFirebase[dateRegisterEmailArg] = DateTime.now();
    }
    if (operation == SaveFirestoreOperation.anonymousRegister) {
      mapToFirebase[dateRegisterAnonymousArg] = DateTime.now();
    }
    return mapToFirebase;
  }

  static Player fromFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) {
      return Player();
    }
    return Player(uid: firebaseUser.uid, email: firebaseUser.email);
  }
}

enum SaveFirestoreOperation { emailRegister, anonymousRegister, update }

class PlayerFireDtbPath {
  static const String users = 'users';
}
