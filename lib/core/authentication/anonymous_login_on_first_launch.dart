import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/user_firebase.dart';
import 'package:hex_game/core/local_storage.dart';
import 'package:hex_game/ui/loading/loading_screens.dart';

class InitFirebaseUserOnFirstLaunch extends StatelessWidget {
  final Widget child;
  InitFirebaseUserOnFirstLaunch({required this.child});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: LocalStorage.userAlreadyOpenApp(),
      builder: (context, hasAlreadyOpenSnapshot) {
        if (hasAlreadyOpenSnapshot.hasError) {
          print("Error - return function userAlreadyOpenApp");
          return child;
        } else if (!hasAlreadyOpenSnapshot.hasData) {
          return LoadingMaterialAppScreen(
              subtitle: "Checking first time open the app");
        } else if (hasAlreadyOpenSnapshot.hasData &&
            hasAlreadyOpenSnapshot.data == false) {
          return FutureBuilder<String?>(
              future: UserFirebase.signInAnonymously(context: context),
              builder: (context, uidShapshot) {
                if (uidShapshot.hasError) {
                  print("signInAnonymous - Error - initState");
                  return child;
                  //return LoadingPageScreen(message: "Error - StateModel().signInAnonymous()");
                } else if (!uidShapshot.hasData) {
                  return LoadingMaterialAppScreen(
                      subtitle: "Creating anonymous account");
                } else {
                  print("StateModel initialised");
                  return child;
                }
              });
        } else {
          return child;
        }
      },
    );
  }
}
