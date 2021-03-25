import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:intl/intl.dart';

class PageNotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            S.of(context).page_not_found_title,
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(Intl.getCurrentLocale()),
        ],
      ),
    );
  }
}
