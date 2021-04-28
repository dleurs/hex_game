import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/navigation/beam_locations.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({required this.beamerKey});

  final GlobalKey<BeamerState> beamerKey;

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late int _currentIndex;

  @override
  void initState() {
    widget.beamerKey.currentState?.routerDelegate.addListener(() => _updateCurrentIndex());
    if (widget.beamerKey.currentState?.currentLocation is HomeLocation) {
      _currentIndex = 0;
    } else if (widget.beamerKey.currentState?.currentLocation is GameLocation) {
      _currentIndex = 1;
    } else {
      _currentIndex = 2;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= 2) {
      return SizedBox();
    }
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Game', icon: Icon(FlutterIconCom.nut)),
        ],
        onTap: (index) {
          widget.beamerKey.currentState?.routerDelegate.beamTo(beamLocations[index]);
        });
  }

  void _updateCurrentIndex() {
    int index;
    if (widget.beamerKey.currentState?.currentLocation is HomeLocation) {
      index = 0;
    } else if (widget.beamerKey.currentState?.currentLocation is GameLocation) {
      index = 1;
    } else {
      index = 2;
    }
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }
}
