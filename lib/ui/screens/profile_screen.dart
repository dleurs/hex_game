import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(ProfileScreen.uri.path),
    child: ProfileScreen(),
  );
  static final Uri uri = Uri(path: "/profile");

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                S.of(context).profile_title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
