import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/generated/l10n.dart';

class LoadingMaterialAppScreen extends StatelessWidget {
  final String subtitle;
  LoadingMaterialAppScreen({this.subtitle = "This is a test"});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hex game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  LoadingScaffoldScreen({this.subtitle = "This is a test", this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        actions: actions ?? [],
        leading: SizedBox(),
      ),
      body: LoadingBodyScreen(subtitle: subtitle),
    );
  }
}

class LoadingBodyScreen extends StatelessWidget {
  final String subtitle;
  LoadingBodyScreen({this.subtitle = "This is a test"});
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
