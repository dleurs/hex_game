import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/navigation/app_location.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  BottomNavigationBarWidget({required this.beamerKey});

  final GlobalKey<BeamerState> beamerKey;

  @override
  _BottomNavigationBarWidgetState createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _currentIndex = 0;

  @override
  void initState() {
    widget.beamerKey.currentState?.routerDelegate.addListener(() => _updateCurrentIndex());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: 'Game', icon: Icon(Icons.article)),
        ],
        onTap: (index) {
          widget.beamerKey.currentState?.routerDelegate.beamTo(beamLocations[index]);
        });
  }

  void _updateCurrentIndex() {
    final index = (widget.beamerKey.currentState?.currentLocation is AppLocation) ? 0 : 1;
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }
}
