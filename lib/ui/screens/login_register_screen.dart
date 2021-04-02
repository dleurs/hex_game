import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoginRegisterScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(LoginRegisterScreen.uri.path),
    child: LoginRegisterScreen(),
  );
  static final Uri uri = Uri(path: "/welcome");

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Consumer<User?>(builder: (context, user, child) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Log / Register here",
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
