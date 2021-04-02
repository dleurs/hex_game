import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';

class LoadingMaterialAppScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  LoadingMaterialAppScreen({this.title = "", this.subtitle = ""});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linkia',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScaffoldScreen(
        subtitle: subtitle,
      ),
    );
  }
}

class LoadingScaffoldScreen extends StatelessWidget {
  final String subtitle;
  final List<Widget>? actions;
  LoadingScaffoldScreen({this.subtitle = "", this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).hex_game_title),
        actions: actions ?? [],
        leading: SizedBox(),
      ),
      body: LoadingBodyScreen(subtitle: subtitle),
    );
  }
}

class LoadingBodyScreen extends StatelessWidget {
  final String subtitle;
  LoadingBodyScreen({this.subtitle = ""});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Column(
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 100,
        ),
        CircularProgressIndicator(),
      ],
    )));
  }
}
