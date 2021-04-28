import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/game_room_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/utils/helpers.dart';

class HomeLocation extends BeamLocation {
  HomeLocation(BeamState state) : super(state);
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
  GameLocation(BeamState state) : super(state);
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
  AppBarLocation(BeamState state) : super(state);
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
}

List<BeamLocation<BeamState>> beamLocations = [
  HomeLocation(BeamState.fromUri(HomeScreen.uri)),
  GameLocation(BeamState.fromUri(GameRoomScreen.uri)),
  AppBarLocation(BeamState.fromUri(PlayersScreen.uri)),
];