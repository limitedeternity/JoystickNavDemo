import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Widget page;
  FadePageRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

  @override
  bool get fullscreenDialog => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 450);
}
