import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/core/authentication/authentication_manager.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/responsive_designs.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:provider/provider.dart';

// DATA
List<Player> players = [
  Player(uid: "123", pseudo: "Georges101", email: "georges@gmail.com"),
  Player(uid: "456", pseudo: "Martin", email: "martin@gmail.com"),
  Player(uid: "789", pseudo: "Sacha", email: "sacha@gmail.com"),
];

class PlayersScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(PlayersScreen.uri.path),
    child: PlayersScreen(),
  );
  static final Uri uri = Uri(path: "/players");

  static final queryParameterPlayer = 'player';

  static final playerSlug = 'playerSlug';

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends BaseScreenState<PlayersScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    final String playerQuery =
        context.currentBeamLocation.state.queryParameters[PlayersScreen.queryParameterPlayer] ?? '';

    return StreamProvider<List<Player>>(
      create: (BuildContext context) => AuthenticationApiProvider().getSteamPlayersWithPseudo(),
      initialData: [],
      child: Consumer<List<Player>>(builder: (context, listPlayer, __) {
        if (listPlayer.isEmpty) {
          return Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
          );
        }
        return ResponsiveDesign.centeredAndMaxWidth(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: listPlayer
                .where((player) => (player.pseudo!.toLowerCase().contains(playerQuery.toLowerCase())))
                .map(
                  (player) => ListTile(
                    title: Text(player.pseudo!),
                    //onTap: () => beamToNamed('/players/${player.pseudo}'),
                    onTap: () => context.currentBeamLocation.update(
                      (state) => state.copyWith(
                        pathBlueprintSegments: [PlayersScreen.uri.pathSegments[0], ':' + PlayersScreen.playerSlug],
                        pathParameters: {PlayersScreen.playerSlug: player.pseudo!},
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }
}
