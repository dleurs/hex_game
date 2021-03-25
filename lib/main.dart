import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/navigation/hex_location.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy(); // Remove the "#" from the url
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerRouterDelegate(
    notFoundPage: BeamPage(
      key: UniqueKey(),
      child: PageNotFoundScreen(),
    ),
    beamLocations: [
      HexLocation(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Hex Game",
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerRouteInformationParser(),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
