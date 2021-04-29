import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'package:hex_game/ui/screens/base_screen.dart';

class GameRoomScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(GameRoomScreen.uri.path),
    child: GameRoomScreen(),
  );

  static final Uri uri = Uri(path: "/game");

  @override
  _PageNotFoundScreenState createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends BaseScreenState<GameRoomScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Game room screen", //TODO INTL
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
    );
  }
}
