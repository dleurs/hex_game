import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/utils/form_validator.dart';

class PlayerScreen extends StatefulWidget {
  final String? playerSlug;

  PlayerScreen({this.playerSlug});

  static BeamPage beamLocation({String? playerSlug}) {
    return BeamPage(
      key: ValueKey(PlayerScreen.uri(playerSlug: playerSlug).path),
      child: PlayerScreen(
        playerSlug: playerSlug,
      ),
    );
  }

  static Uri uri({String? playerSlug}) {
    return Uri(path: PlayersScreen.uri.path + "/" + (playerSlug ?? ":playerSlug"));
  }

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends BaseScreenState<PlayerScreen> {
  @override
  Widget? buildLeading(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    if (authBloc.isLoggedIn) {
      return BackButton(
        onPressed: () {
          Beamer.of(context).beamToNamed(HomeScreen.uri.path);
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget buildScreen(BuildContext context) {
    String? checkedPlayerSlug;
    if (FormValidators.isPlayerIdValid(widget.playerSlug)) {
      checkedPlayerSlug = widget.playerSlug;
    } else {
      return PageNotFoundScreen();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              S.of(context).profile_title,
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              "Player slug : " + checkedPlayerSlug!,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
                },
                child: Text("Logout"))
          ],
        ),
      ),
    );
  }
}
