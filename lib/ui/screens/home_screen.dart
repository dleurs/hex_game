import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/navigation/hex_location.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).hex_game_title),
      ),
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
                    Beamer.of(context).beamToNamed(RouteNames.profile.fullPath);
                  },
                  child: Text("-> # <-"))
            ],
          ),
        ),
      ),
    );
  }
}
