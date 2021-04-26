import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(HomeScreen.uri.path),
    child: HomeScreen(),
  );
  static final Uri uri = Uri(path: "/");

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              S.of(context).hex_game_title,
              key: Key('HomeScreenTitle'),
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              Intl.getCurrentLocale(),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                authBloc.isLoggedIn ? "User logged " + (authBloc.toString()) : "User not logged",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
