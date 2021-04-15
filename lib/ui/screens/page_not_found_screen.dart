import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/screens/base_screen.dart';

class PageNotFoundScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: UniqueKey(),
    child: PageNotFoundScreen(),
  );

  @override
  _PageNotFoundScreenState createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends BaseScreenState<PageNotFoundScreen> {
  @override
  Widget buildScreen(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              S.of(context).page_not_found_title,
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
      ),
    );
  }
}
