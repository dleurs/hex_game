import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  MainScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(builder: (context, user, child) {
      return Scaffold(
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              Beamer.of(context).beamToNamed(HomeScreen.uri.path);
            },
            child: Text(
              S.of(context).hex_game_title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.headline6!.fontSize),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(FlutterIconCom.group),
              onPressed: () {
                Beamer.of(context).beamToNamed(PlayersScreen.uri.path);
              },
            ),
            IconButton(
              icon: Icon(FlutterIconCom.user),
              onPressed: () {
                Beamer.of(context).beamToNamed(LoginRegisterScreen.uri.path);
              },
            )
          ],
        ),
        body: body,
      );
    });
  }
}
