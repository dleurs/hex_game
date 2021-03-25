import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';

class MainScaffold extends StatelessWidget {
  final Widget body;
  MainScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).hex_game_title),
      ),
      body: body,
    );
  }
}
