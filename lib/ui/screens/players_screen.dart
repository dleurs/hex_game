import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';

// DATA
List<Player> players = [
  Player(uid: "123", pseudo: "Georges101", email: "georges@gmail.com"),
  Player(uid: "456", pseudo: "Martin", email: "martin@gmail.com"),
  Player(uid: "789", pseudo: "Sacha", email: "sacha@gmail.com"),
];

class PlayersScreen extends StatelessWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(PlayersScreen.uri.path),
    child: PlayersScreen(),
  );
  static final Uri uri = Uri(path: "/players");

  static final queryParameterPlayer = 'player';

  @override
  Widget build(BuildContext context) {
    final String playerQuery = context.currentBeamLocation.state
            .queryParameters[PlayersScreen.queryParameterPlayer] ??
        '';

    return MainScaffold(
      body: Center(
          child: ListView(
        children: players
            .where((player) => (player.pseudo != null &&
                player.pseudo!
                    .toLowerCase()
                    .contains(playerQuery.toLowerCase())))
            .map(
              (player) => ListTile(
                title: Text(player.pseudo!),
                subtitle: Text(player.email!),
                //onTap: () => context.beamToNamed('/books/${book['id']}'),
                onTap: () => context.currentBeamLocation.update(
                  (state) => state.copyWith(
                    pathBlueprintSegments: ['player', ':playerSlug'],
                    pathParameters: {'playerSlug': player.pseudo!},
                  ),
                ),
              ),
            )
            .toList(),
      )),
    );
  }
}
