import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/utils/exceptions.dart';

class AuthenticationApiProvider {
  //ArtemisClient get _client => ArtemisClient(Config.authApiEndpoint);
  var dbAuth = FirebaseAuth.instance;
  var dbStore = FirebaseFirestore.instance;

  Future<String?> loginAnonymously({required BuildContext context}) async {
    UserCredential userCredential = await dbAuth.signInAnonymously();
    return userCredential.user?.uid ?? null;
  }

  Future<User?> login({required String email, required String password}) async {
    UserCredential userCredential = await dbAuth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> register({required String email, required String password}) async {
    UserCredential userCredential = await dbAuth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> logout() async {
    await dbAuth.signOut();
  }

  Future<Player?> getPlayer({required String uid}) async {
    DocumentSnapshot playerDoc = await dbStore.collection(FirestoreDtbPath.USERS).doc(uid).get();
    print(playerDoc);
    return Player.fromFirebase(playerDoc.data());
  }

  Future<void> deletePlayer({required String uid}) async {
    await dbStore.collection(FirestoreDtbPath.USERS).doc(uid).delete();
  }

  Stream<List<Player>> getSteamPlayersWithPseudo() {
    return dbStore
        .collection(FirestoreDtbPath.USERS)
        //.where(Player.PSEUDO, isNotEqualTo: null)
        //.orderBy('lastModify', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((document) => Player.fromFirebase(document.data())).toList(),
        );
  }

  Future<void> updatePlayer(
      {required Player player, required SaveFirestoreOperation operation, bool merge = true}) async {
    return await dbStore.collection(FirestoreDtbPath.USERS).doc(player.uid).set(player.toFirebase(operation: operation),
        SetOptions(merge: merge)); // merge: true to keep dateRegisterAnonymous when converting anon to user
  }

  Future<bool> isPseudoAlreadyUsed({required String pseudo}) async {
    List<DocumentSnapshot> listDocs =
        (await dbStore.collection(FirestoreDtbPath.USERS).where(Player.PSEUDO, isEqualTo: pseudo).get()).docs;
    return (listDocs.isNotEmpty);
  }

  Future<FirebaseAuthException> isEmailAlreadyUsed({required String email}) async {
    try {
      await dbAuth.signInWithEmailAndPassword(email: email, password: "ficjciqcjoj126129"); //TODO Use private variable
      return FirebaseAuthException(code: "user-read-password");
    } on FirebaseAuthException catch (e) {
      print("isEmailAlreadyUsed FirebaseAuthException : " + e.toString());
      return e;
    }
  }

  Future<Player?> createUserWithPseudoEmailAndPassword(
      {required String pseudo, required String email, required String password, required BuildContext context}) async {
    bool pseudoAleadyUsed = await isPseudoAlreadyUsed(pseudo: pseudo);
    print(pseudoAleadyUsed);
    if (pseudoAleadyUsed) {
      throw PseudoAlredyUsedException();
    }
    User? fireUser =
        (await dbAuth.createUserWithEmailAndPassword(email: email, password: password)).user; // also sign in
    if (fireUser == null) {
      return null;
    }
    Player newPlayer = Player(uid: fireUser.uid, pseudo: pseudo, email: email);
    await updatePlayer(player: newPlayer, operation: SaveFirestoreOperation.emailRegister);
    return newPlayer;
  }
}
