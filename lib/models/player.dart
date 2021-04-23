import 'package:flutter/material.dart';

class Player extends ChangeNotifier {
  String? uid;
  bool isAnonymous;
  String? pseudo;
  String? email;
  bool optInNewsletter;
  Player({this.uid, this.isAnonymous = false, this.pseudo, this.email, this.optInNewsletter = false});

  static const String UID = "uid";
  static const String IS_ANONYMOUS = "isAnonymous";
  static const String PSEUDO = "pseudo";
  static const String EMAIL = "email";
  static const String DATE_REGISTER_EMAIL = "dateRegisterEmail";
  static const String DATE_REGISTER_ANONYMOUS = "dateRegisterAnonymous";
  static const String DATE_LAST_UPDATE = "dateLastUpdate";
  static const String OPT_IN_NEWSLETTER = "optInNewsletter";

  bool isLoggedIn() {
    return (uid != null);
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
    return 'Player{$UID: $uid, $IS_ANONYMOUS: $isAnonymous, $PSEUDO: $pseudo, $EMAIL: $email}';
  }

  Map<String, dynamic> toFirebase({required SaveFirestoreOperation operation}) {
    Map<String, dynamic> mapToFirebase = {
      UID: uid,
      IS_ANONYMOUS: isAnonymous,
      PSEUDO: pseudo,
      //EMAIL: email,
      OPT_IN_NEWSLETTER: optInNewsletter,
      DATE_LAST_UPDATE: DateTime.now()
    };
    if (operation == SaveFirestoreOperation.emailRegister) {
      mapToFirebase[DATE_REGISTER_EMAIL] = DateTime.now();
    }
    if (operation == SaveFirestoreOperation.anonymousRegister) {
      mapToFirebase[DATE_REGISTER_ANONYMOUS] = DateTime.now();
    }
    return mapToFirebase;
  }

  static Player fromFirebase(Map<String, dynamic>? fireDoc) {
    if (fireDoc == null) {
      return Player();
    }
    return Player(uid: fireDoc[UID], pseudo: fireDoc[PSEUDO]);
  }
}

enum SaveFirestoreOperation { emailRegister, anonymousRegister, update }

class FirestoreDtbPath {
  static const String USERS = 'users';
}
