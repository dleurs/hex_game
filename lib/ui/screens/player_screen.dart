import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/utils/form_validator.dart';

class PlayerScreen extends StatelessWidget {
  final String? playerSlug;

  PlayerScreen({this.playerSlug});

  static BeamPage beamLocation({String? playerSlug}) {
    return BeamPage(
      key: ValueKey(PlayerScreen.uri(playerSlug: playerSlug).path),
      child: PlayerScreen(
        playerSlug: playerSlug,
      ),
    );
  }

  static Uri uri({String? playerSlug}) {
    return Uri(
        path: PlayersScreen.uri.path + "/" + (playerSlug ?? ":playerSlug"));
  }

  @override
  Widget build(BuildContext context) {
    String? checkedPlayerSlug;
    if (FormValidators.isPlayerIdValid(playerSlug)) {
      checkedPlayerSlug = playerSlug;
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
                "Player slug : " + checkedPlayerSlug!,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
