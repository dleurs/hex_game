import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';

class PlayerScreen extends StatelessWidget {
  final String? playerId;

  PlayerScreen({this.playerId});

  static BeamPage beamLocation({String? playerId}) {
    return BeamPage(
      key: ValueKey(PlayerScreen.uri.path),
      child: PlayerScreen(
        playerId: playerId,
      ),
    );
  }

  static final Uri uri = Uri(path: "/player/:playerId");

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                S.of(context).profile_title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                (playerId != null)
                    ? ("Player id : " + (playerId ?? ""))
                    : "Player id not set",
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
