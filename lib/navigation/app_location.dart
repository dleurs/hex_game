import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/navigation/beam_locations.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';

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
    _currentIndex = widget.beamState.uri.path.contains('home') ? 1 : 0;
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
          //BottomNavigationBarItem(label: 'Player', icon: Icon(FlutterIconCom.nut)),
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
