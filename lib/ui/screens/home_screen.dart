import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/utils/keys_name.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(HomeScreen.uri.path),
    child: HomeScreen(),
  );
  static final Uri uri = Uri(path: "/home");

  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  final items = List<String>.generate(100, (i) => "Item $i");

  @override
  Widget buildScreen(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              height: AppDimensions.mediumHeight,
            ),
            Text(
              S.of(context).hex_game_title,
              key: Key(KeysName.HOME_SCREEN_TITLE),
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
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${items[index]}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
