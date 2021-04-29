import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/hex_board/game_room_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';

class HomeLocation extends BeamLocation {
  HomeLocation(this.beamState);

  final BeamState beamState;

  @override
  List<String> get pathBlueprints => [
        HomeScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      HomeScreen.beamLocation,
    ];
  }
}

class GameLocation extends BeamLocation {
  GameLocation(this.beamState);

  final BeamState beamState;
  @override
  List<String> get pathBlueprints => [
        GameRoomScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      GameRoomScreen.beamLocation,
    ];
  }
}

class AppBarLocation extends BeamLocation {
  AppBarLocation(this.beamState);

  final BeamState beamState;

  //AppBarLocation(BeamState state) : super(state);
  @override
  List<String> get pathBlueprints => [
        PlayerScreen.uri().path,
        LoginRegisterScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains(LoginRegisterScreen.uri.pathSegments[0])) //
        LoginRegisterScreen.beamLocation,
      if (state.uri.pathSegments.contains(PlayersScreen.uri.pathSegments[0])) //
        PlayersScreen.beamLocation,
      if (state.pathParameters.containsKey(PlayerScreen.PLAYER_PSEUDO))
        PlayerScreen.beamLocation(playerPseudo: state.pathParameters[PlayerScreen.PLAYER_PSEUDO]),
    ];
  }

  static Widget? buildLeadingFirstLayer(BuildContext context) => BackButton(
        onPressed: () {
          if (Beamer.of(context).canPopBeamLocation) {
            Beamer.of(context).popBeamLocation();
          } else {
            Beamer.of(context).beamToNamed(HomeScreen.uri.path);
          }
        },
      );
}
