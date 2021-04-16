import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/utils/exceptions.dart';
import 'package:tuple/tuple.dart';

class AuthenticationApiProvider {
  //ArtemisClient get _client => ArtemisClient(Config.authApiEndpoint);
  var dbAuth = FirebaseAuth.instance;
  var dbStore = FirebaseFirestore.instance;

  Future<String?> loginAnonymously({required BuildContext context}) async {
    try {
      UserCredential userCredential = await dbAuth.signInAnonymously();
      return userCredential.user?.uid ?? null;
    } catch (e) {
      print("Error: " + e.toString());
    }
  }

  Future<User?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await dbAuth.signInWithEmailAndPassword(
          email: email, password: password);
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

  Future<Player?> getPlayer({required String uid}) async {
    DocumentSnapshot playerDoc =
        await dbStore.collection(PlayerFireDtbPath.users).doc(uid).get();
    print(playerDoc);
    return Player.fromFirebaseUser(playerDoc); //TODO
  }

  Future<void> updatePlayer(
      {required Player player,
      required SaveFirestoreOperation operation,
      bool merge = true}) async {
    return await dbStore.collection(PlayerFireDtbPath.users).doc(player.uid).set(
        player.toFirebase(operation: operation),
        SetOptions(
            merge:
                merge)); // merge: true to keep dateRegisterAnonymous when converting anon to user
  }

  Future<bool> isPseudoAlreadyUsed({required String pseudo}) async {
    List<DocumentSnapshot> listDocs = (await dbStore
            .collection(PlayerFireDtbPath.users)
            .where(Player.pseudoArg, isEqualTo: pseudo)
            .get())
        .docs;
    return (listDocs.isNotEmpty);
  }

/*   static Future<bool> isEmailAlreadyUsedFirestore(
      {required String email}) async {
    List<DocumentSnapshot> listDocs = (await FirebaseFirestore.instance
            .collection(PlayerFireDtbPath.users)
            .where(Player.emailArg, isEqualTo: email)
            .get())
        .docs;
    return (listDocs.isNotEmpty);
  } */

  Future<bool> isEmailAlreadyUsed({required String email}) async {
    try {
      await dbAuth.signInWithEmailAndPassword(
          email: email,
          password: "ficjciqcjoj126129"); //TODO Use private variable
      return false;
    } on FirebaseAuthException catch (e) {
      print("isEmailAlreadyUsed FirebaseAuthException : " + e.toString());
      if (e.code == 'wrong-password') {
        return true;
      }
      return false;
    }
  }

  Future<Player?> createUserWithPseudoEmailAndPassword(
      {required String pseudo,
      required String email,
      required String password,
      required BuildContext context}) async {
    bool pseudoAleadyUsed = await isPseudoAlreadyUsed(pseudo: pseudo);
    print(pseudoAleadyUsed);
    if (pseudoAleadyUsed) {
      throw PseudoAlredyUsedException();
    }
    User? fireUser = (await dbAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user; // also sign in
    if (fireUser == null) {
      return null;
    }
    Player newPlayer = Player(uid: fireUser.uid, pseudo: pseudo, email: email);
    await updatePlayer(
        player: newPlayer, operation: SaveFirestoreOperation.emailRegister);
    return newPlayer;
  }
}
