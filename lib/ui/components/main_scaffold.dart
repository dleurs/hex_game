import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/players_screen.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  MainScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).hex_game_title),
        actions: [
          IconButton(
              icon: Icon(FlutterIconCom.user),
              onPressed: () {
                Beamer.of(context).beamToNamed(PlayersScreen.uri.path);
              })
        ],
      ),
      body: body,
    );
  }
}
