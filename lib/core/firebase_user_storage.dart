import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/utils/exceptions.dart';

class FirestoreUserStorage {
  static Future<void> updatePlayer(
      {required Player player,
      required SaveFirestoreOperation operation,
      bool merge = true}) async {
    return await FirebaseFirestore.instance
        .collection(PlayerFireDtbPath.users)
        .doc(player.uid)
        .set(
            player.toFirebase(operation: operation),
            SetOptions(
                merge:
                    merge)); // merge: true to keep dateRegisterAnonymous when converting anon to user
  }

  static Future<bool> isPseudoAlreadyUsed({required String pseudo}) async {
    List<DocumentSnapshot> listDocs = (await FirebaseFirestore.instance
            .collection(PlayerFireDtbPath.users)
            .where(Player.pseudoArg, isEqualTo: pseudo)
            .get())
        .docs;
    return (listDocs.isNotEmpty);
  }

  static Future<Player?> createUserWithPseudoEmailAndPassword(
      {required String pseudo,
      required String email,
      required String password,
      required BuildContext context}) async {
    bool pseudoAleadyUsed =
        await FirestoreUserStorage.isPseudoAlreadyUsed(pseudo: pseudo);
    print(pseudoAleadyUsed);
    if (pseudoAleadyUsed) {
      throw PseudoAlredyUsedException();
    }
    User? fireUser = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password))
        .user; // also sign in
    if (fireUser == null) {
      return null;
    }
    Player newPlayer = Player(uid: fireUser.uid, pseudo: pseudo);
    await FirestoreUserStorage.updatePlayer(
        player: newPlayer, operation: SaveFirestoreOperation.emailRegister);
    return newPlayer;
  }
}
