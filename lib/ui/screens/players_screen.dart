import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:intl/intl.dart';

class PlayersScreen extends StatelessWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(PlayersScreen.uri.path),
    child: PlayersScreen(),
  );
  static final Uri uri = Uri(path: "/player");

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "List of all players",
                //S.of(context).profile_title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
