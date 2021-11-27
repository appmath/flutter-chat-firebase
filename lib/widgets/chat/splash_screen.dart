import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Text('Loading...'),
    );
  }
}
