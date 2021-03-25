import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(HomeScreen.uri.path),
    child: HomeScreen(),
  );
  static final Uri uri = Uri(path: "/");

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                S.of(context).hex_game_title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(Intl.getCurrentLocale()),
              ElevatedButton(
                  onPressed: () {
                    Beamer.of(context).beamToNamed(PlayersScreen.uri.path);
                  },
                  child: Text("-> # <-"))
            ],
          ),
        ),
      ),
    );
  }
}
