import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/utils/form_validator.dart';
import 'package:hex_game/utils/helpers.dart';
import 'package:hex_game/utils/keys_name.dart';

class PlayerScreen extends StatefulWidget {
  final String? playerPseudo;

  static const String PLAYER_PSEUDO = "playerPseudo";

  PlayerScreen({this.playerPseudo});

  static BeamPage beamLocation({String? playerPseudo}) {
    return BeamPage(
      key: ValueKey(PlayerScreen.uri(playerPseudo: playerPseudo).path),
      child: PlayerScreen(
        playerPseudo: playerPseudo,
      ),
    );
  }

  static Uri uri({String? playerPseudo}) {
    return Uri(path: PlayersScreen.uri.path + "/" + (playerPseudo ?? ":" + PlayerScreen.PLAYER_PSEUDO));
  }

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends BaseScreenState<PlayerScreen> {
  @override
  Widget? buildLeading(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    if (authBloc.isLoggedIn && widget.playerPseudo != null && widget.playerPseudo! == authBloc.pseudo) {
      return BackButton(
        onPressed: () {
          Beamer.of(context).beamBack();
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget buildScreen(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    String? checkedPlayerPseudo;
    if (FormValidators.isPlayerIdValid(widget.playerPseudo)) {
      checkedPlayerPseudo = widget.playerPseudo;
    } else {
      return PageNotFoundScreen();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: toList(
            () sync* {
              yield Text(
                S.of(context).profile_title,
                key: Key(KeysName.PLAYER_SCREEN_TITLE),
                style: Theme.of(context).textTheme.headline3,
              );
              yield SizedBox(height: AppDimensions.mediumHeight);
              yield Text(
                "Player pseudo : " + checkedPlayerPseudo!,
                style: Theme.of(context).textTheme.headline6,
              );
              yield SizedBox(height: AppDimensions.mediumHeight);
              if (authBloc.isLoggedIn && widget.playerPseudo != null && widget.playerPseudo! == authBloc.pseudo) {
                yield ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 120, height: 50),
                  child: ElevatedButton(
                    key: Key(KeysName.PLAYER_SCREEN_BUTTON_LOGOUT),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
                    },
                    child: Text("Logout"), //TODO INTL
                  ),
                );
                yield SizedBox(height: AppDimensions.mediumHeight);
                yield ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 120, height: 50),
                  child: ElevatedButton(
                    key: Key(KeysName.PLAYER_SCREEN_BUTTON_DELETE_USER),
                    onPressed: () {
                      BlocProvider.of<AuthenticationBloc>(context).add(DeleteUserEvent());
                    },
                    child: (authBloc.state is AuthenticationProcessing)
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text("Delete User"), //TODO INTL
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
