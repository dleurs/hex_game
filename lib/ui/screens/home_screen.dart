import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    return Consumer<User?>(builder: (context, user, child) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                S.of(context).hex_game_title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                Intl.getCurrentLocale(),
              ),
              Text(
                user?.uid ?? "User not connected",
              ),
            ],
          ),
        ),
      );
    });
  }
}
