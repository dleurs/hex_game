import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/utils/keys_name.dart';
import 'package:provider/provider.dart';

class PlayersScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(PlayersScreen.uri.path),
    child: PlayersScreen(),
  );
  static final Uri uri = Uri(path: "/players");

  static final queryParameterPlayer = 'player';

  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends BaseScreenState<PlayersScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    final String playerQuery =
        context.currentBeamLocation.state.queryParameters[PlayersScreen.queryParameterPlayer] ?? '';

    return ListView(children: <Widget>[
      SizedBox(
        height: AppDimensions.smallHeight,
      ),
      Center(
        child: Text(
          "Players",
          key: Key(KeysName.PLAYERS_SCREEN_TITLE),
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      SizedBox(
        height: AppDimensions.smallHeight,
      ),
      StreamBuilder<List<Player>>(
          stream: AuthenticationApiProvider().getSteamPlayersWithPseudo(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData || (snapshot.hasData && snapshot.data.isEmpty)) {
              return Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }
            List<Player> listPlayer = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    //shrinkWrap: true,
                    itemCount: listPlayer.length,
                    itemBuilder: (context, index) {
                      Player player = listPlayer[index];
                      return ListTile(
                        title: Text(player.pseudo!),
                        subtitle: (player.dateRegister != null)
                            ? Text("Created in " + player.dateRegister!)
                            : SizedBox(), //TODO INTL
                        //onTap: () => beamToNamed('/players/${player.pseudo}'),
                        onTap: () => context.currentBeamLocation.update(
                          (state) => state.copyWith(
                            pathBlueprintSegments: [
                              PlayersScreen.uri.pathSegments[0],
                              ':' + PlayerScreen.PLAYER_PSEUDO
                            ],
                            pathParameters: {PlayerScreen.PLAYER_PSEUDO: player.pseudo!},
                          ),
                        ),
                      );
                    },
                    //scrollDirection: Axis.vertical,
/*                           shrinkWrap: true,
                    children: listPlayer
                        .where(
                            (Player player) => (player.pseudo!.toLowerCase().contains(playerQuery.toLowerCase())))
                        .map(
                          (player) => ListTile(
                            title: Text(player.pseudo!),
                            subtitle: (player.dateRegister != null)
                                ? Text("Created in " + player.dateRegister!)
                                : SizedBox(), //TODO INTL
                            //onTap: () => beamToNamed('/players/${player.pseudo}'),
                            onTap: () => context.currentBeamLocation.update(
                              (state) => state.copyWith(
                                pathBlueprintSegments: [
                                  PlayersScreen.uri.pathSegments[0],
                                  ':' + PlayerScreen.PLAYER_PSEUDO
                                ],
                                pathParameters: {PlayerScreen.PLAYER_PSEUDO: player.pseudo!},
                              ),
                            ),
                          ),
                        )
                        .toList(), */
                  ),
                ),
              ),
            );
          }),
    ]);
  }
}
