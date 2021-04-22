import 'package:beamer/beamer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/navigation/hex_location.dart';
import 'package:hex_game/ui/screens/page_not_found_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'bloc/form_login_register/form_login_register_bloc.dart';

Future<void> main() async {
  setPathUrlStrategy(); // Remove the "#" from the url
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //TODO Check how Firebase Analytics works
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerRouterDelegate(
    notFoundPage: BeamPage(
      key: UniqueKey(),
      child: PageNotFoundScreen(),
    ),
    beamLocations: [
      AppLocation(),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(create: (context) => AuthenticationBloc(AuthenticationApiProvider())),
          BlocProvider<FormLoginRegisterBloc>(create: (context) => FormLoginRegisterBloc(AuthenticationApiProvider())),
        ],
        child: MaterialApp.router(
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
        ));
  }
}
