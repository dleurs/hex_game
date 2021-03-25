import 'package:beamer/beamer.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';

class HexLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [PlayerScreen.uri().path];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) {
    return [
      HomeScreen.beamLocation,
      if (state.uri.pathSegments
          .contains(PlayersScreen.uri.pathSegments[0])) ...[
        PlayersScreen.beamLocation,
        if (state.pathParameters.containsKey('playerId'))
          PlayerScreen.beamLocation(playerId: state.pathParameters['playerId']),
      ]
    ];
  }
}
