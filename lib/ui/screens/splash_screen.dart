import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  String? message;
  SplashScreen({this.message});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.message ?? "Loading", // TODO INTL
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
