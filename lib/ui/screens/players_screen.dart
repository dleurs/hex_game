import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:intl/intl.dart';

// DATA
List<Player> players = [
  Player(uuid: "123", pseudo: "Georges101", email: "georges@gmail.com"),
  Player(uuid: "456", pseudo: "Martin", email: "martin@gmail.com"),
  Player(uuid: "789", pseudo: "Sacha", email: "sacha@gmail.com"),
];

class PlayersScreen extends StatelessWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(PlayersScreen.uri.path),
    child: PlayersScreen(),
  );
  static final Uri uri = Uri(path: "/player");

  @override
  Widget build(BuildContext context) {
    final String playerQuery =
        context.currentBeamLocation.state.queryParameters['player'] ?? '';

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
                    pathBlueprintSegments: ['player', ':playerId'],
                    pathParameters: {'playerId': player.pseudo!},
                  ),
                ),
              ),
            )
            .toList(),
      )),
    );
  }
}
