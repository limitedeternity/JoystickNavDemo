import 'package:flutter/material.dart';
import 'package:joystickNavDemo/pages/cardScreen.dart';

void main() {
  runApp(JoystickNavDemo());
}

class JoystickNavDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JoystickNavDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("JoystickNavDemo"),
        ),
        body: CardScreen(),
      ),
    );
  }
}
