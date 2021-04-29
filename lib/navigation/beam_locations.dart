import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/hex_board/game_room_screen.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';

class AppLocation extends BeamLocation {
  AppLocation(state) : super(state);

  @override
  List<String> get pathBlueprints => ['/*'];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('app-${state.uri}'),
          child: AppScreen(beamState: state),
        ),
      ];
}

class AppScreen extends StatefulWidget {
  AppScreen({required this.beamState});

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
  ];

  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.beamState.uri.path.contains('home') ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Beamer(routerDelegate: _routerDelegates[0]),
          Container(
            color: Colors.blueAccent,
            padding: const EdgeInsets.all(32.0),
            child: Beamer(routerDelegate: _routerDelegates[1]),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(label: 'A', icon: Icon(Icons.article)),
          BottomNavigationBarItem(label: 'B', icon: Icon(Icons.book)),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          _routerDelegates[_currentIndex].parent?.updateRouteInformation(
                _routerDelegates[_currentIndex].currentLocation.state.uri,
              );
        },
      ),
    );
  }
}

class HomeLocation extends BeamLocation {
  HomeLocation({required this.beamState});

  final BeamState beamState;

  @override
  List<String> get pathBlueprints => [
        HomeScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      HomeScreen.beamLocation,
    ];
  }
}

class GameLocation extends BeamLocation {
  GameLocation({required this.beamState});

  final BeamState beamState;
  @override
  List<String> get pathBlueprints => [
        GameRoomScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      GameRoomScreen.beamLocation,
    ];
  }
}

class AppBarLocation extends BeamLocation {
  AppBarLocation({required this.beamState});

  final BeamState beamState;

  //AppBarLocation(BeamState state) : super(state);
  @override
  List<String> get pathBlueprints => [
        PlayerScreen.uri().path,
        LoginRegisterScreen.uri.path,
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains(LoginRegisterScreen.uri.pathSegments[0])) //
        LoginRegisterScreen.beamLocation,
      if (state.uri.pathSegments.contains(PlayersScreen.uri.pathSegments[0])) //
        PlayersScreen.beamLocation,
      if (state.pathParameters.containsKey(PlayerScreen.PLAYER_PSEUDO))
        PlayerScreen.beamLocation(playerPseudo: state.pathParameters[PlayerScreen.PLAYER_PSEUDO]),
    ];
  }

  static Widget? buildLeadingFirstLayer(BuildContext context) => BackButton(
        onPressed: () {
          if (Beamer.of(context).canPopBeamLocation) {
            Beamer.of(context).popBeamLocation();
          } else {
            Beamer.of(context).beamToNamed(HomeScreen.uri.path);
          }
        },
      );
}

List<BeamLocation<BeamState>> beamLocations = [HomeLocation(), GameLocation(), AppBarLocation()];
