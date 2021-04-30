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
  static final GlobalKey<_AppScreenState> globalKey = GlobalKey();
  AppScreen(this.beamState) : super(key: globalKey);

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

  void moveTab(int index) {
    setState(() => _currentIndex = index);
    _routerDelegates[index].parent?.updateRouteInformation(
          _routerDelegates[_currentIndex].currentLocation.state.uri,
        );
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    if (widget.beamState.uri.path.contains(HomeScreen.uri.pathSegments[0])) {
      _currentIndex = 0;
    } else if (widget.beamState.uri.path.contains(GameRoomScreen.uri.pathSegments[0])) {
      _currentIndex = 1;
    } else if (widget.beamState.uri.path.contains(PlayersScreen.uri.pathSegments[0])) {
      _currentIndex = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            Beamer(routerDelegate: _routerDelegates[0]),
            Beamer(routerDelegate: _routerDelegates[1]),
            Beamer(routerDelegate: _routerDelegates[2]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: 'Game', icon: Icon(FlutterIconCom.nut)),
            BottomNavigationBarItem(label: 'Player', icon: Icon(FlutterIconCom.group)),
          ],
          onTap: (index) {
            moveTab(index);
          },
        ));
  }
}
