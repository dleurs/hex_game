import 'package:beamer/beamer.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:hex_game/ui/screens/profile_screen.dart';

class HexLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [ProfileScreen.uri.path];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) {
    return [
      HomeScreen.beamLocation,
      if (state.uri.pathSegments.contains(ProfileScreen.uri.pathSegments[0]))
        ProfileScreen.beamLocation
    ];
  }
}
