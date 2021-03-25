import 'package:beamer/beamer.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/profile_screen.dart';

class HexLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [RouteNames.profile.fullPath];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) {
    return [
      BeamPage(
        key: ValueKey(RouteNames.home.segment),
        child: HomeScreen(),
      ),
      if (state.uri.pathSegments.contains(RouteNames.profile.segment))
        BeamPage(
          key: ValueKey(RouteNames.profile.segment),
          child: ProfileScreen(),
        )
    ];
  }
}

class RouteNames {
  static final home = RouteName(segment: "home", fullPath: "/");
  static final profile = RouteName(segment: "profile", fullPath: "/profile");
}

class RouteName {
  final String segment;
  final String fullPath;
  RouteName({required this.segment, required this.fullPath});
}
