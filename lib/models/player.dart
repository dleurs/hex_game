class Player {
  String uid;
  bool isAnonymous;
  String? pseudo;
  String? email;
  bool optInNewsletter;
  Player(
      {required this.uid,
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
}

enum SaveFirestoreOperation { emailRegister, anonymousRegister, update }

class PlayerFireDtbPath {
  static const String users = 'users';
}
