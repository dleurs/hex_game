import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/authentication_manager.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
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

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget buildScreen(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                AuthenticationManager.instance.isLoggedIn
                    ? "User logged " + (AuthenticationManager.instance.toString())
                    : "User not logged",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
