import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/utils/form_validator.dart';

class PlayerScreen extends StatelessWidget {
  final String? playerId;

  PlayerScreen({this.playerId});

  static BeamPage beamLocation({String? playerId}) {
    return BeamPage(
      key: ValueKey(PlayerScreen.uri(playerId: playerId).path),
      child: PlayerScreen(
        playerId: playerId,
      ),
    );
  }

  static Uri uri({String? playerId}) {
    return Uri(path: "/player/" + (playerId ?? ":playerId"));
  }

  @override
  Widget build(BuildContext context) {
    String? checkedPlayerIdSlug;
    if (FormValidators.isPlayerIdValid(playerId)) {
      checkedPlayerIdSlug = playerId;
    } else {
      return PageNotFoundScreen();
    }

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
                (checkedPlayerIdSlug != null)
                    ? ("Player id slug : " + (checkedPlayerIdSlug ?? ""))
                    : "Player id slug not set",
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
