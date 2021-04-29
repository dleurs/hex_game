import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/bloc/form_login_register/form_login_register_bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/navigation/beam_locations.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/hex_board/game_room_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/utils/keys_name.dart';

class AppLocation extends BeamLocation {
  AppLocation(state) : super(state);

  @override
  List<String> get pathBlueprints => ['/*'];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('app-${state.uri}'),
          child: AppScreen(state),
        ),
      ];
}

class AppScreen extends StatefulWidget {
  AppScreen(this.beamState);

  final BeamState beamState;

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _routerDelegates = [
    BeamerRouterDelegate(
      locationBuilder: (state) => HomeLocation(state),
    ),
    BeamerRouterDelegate(
      locationBuilder: (state) => GameLocation(state),
    ),
    BeamerRouterDelegate(
      locationBuilder: (state) => AppBarLocation(state),
    ),
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.beamState.uri.path.contains('home')) {
      _currentIndex = 0;
    } else if (widget.beamState.uri.path.contains('game')) {
      _currentIndex = 1;
    } else {
      _currentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          key: Key(KeysName.BASE_SCREEN_BUTTON_GOTO_HOME),
          onPressed: () {
            Beamer.of(context).beamToNamed(HomeScreen.uri.path);
          },
          child: Text(
            S.of(context).hex_game_title,
            style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.headline6!.fontSize),
          ),
        ),
        //leading: buildLeading(context),
        actions: [
          IconButton(
            icon: Icon(FlutterIconCom.group),
            key: Key(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYERS),
            onPressed: () {
              var index = 2;
              setState(() => _currentIndex = index);
              _routerDelegates[index].parent?.updateRouteInformation(
                    _routerDelegates[index].currentLocation.state.uri,
                  );
              Beamer.of(context).beamToNamed(PlayersScreen.uri.path);

              //Beamer.of(context).beamToNamed(PlayersScreen.uri.path);
            },
          ),
          IconButton(
            icon: Icon(FlutterIconCom.user),
            key: Key(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYER),
            onPressed: () {
              if (authBloc.isLoggedIn && (authBloc.pseudo?.isNotEmpty ?? false)) {
                Beamer.of(context).beamToNamed(PlayerScreen.uri(playerPseudo: authBloc.pseudo).path);
              } else {
                BlocProvider.of<FormLoginRegisterBloc>(context).add(CheckEmailResetEvent());
                Beamer.of(context).beamToNamed(LoginRegisterScreen.uri.path);
              }
            },
          )
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(routerDelegate: _routerDelegates[0]),
          Beamer(routerDelegate: _routerDelegates[1]),
          Beamer(routerDelegate: _routerDelegates[2]),
        ],
      ),
      bottomNavigationBar: (_currentIndex <= 1)
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              items: [
                BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
                BottomNavigationBarItem(label: 'Game', icon: Icon(FlutterIconCom.nut)),
                //BottomNavigationBarItem(label: 'Player', icon: Icon(FlutterIconCom.nut)),
              ],
              onTap: (index) {
                setState(() => _currentIndex = index);
                _routerDelegates[_currentIndex].parent?.updateRouteInformation(
                      _routerDelegates[_currentIndex].currentLocation.state.uri,
                    );
                _routerDelegates[_currentIndex]
/*                 if (index == 0) {
                  Beamer.of(context).beamToNamed(HomeScreen.uri.path);
                } else if (index == 1) {
                  Beamer.of(context).beamToNamed(GameRoomScreen.uri.path);
                } */
              },
            )
          : SizedBox(),
    );
  }
}
