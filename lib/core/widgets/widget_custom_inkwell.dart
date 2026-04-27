import 'package:flutter/material.dart';

class WidgetCustomInkWell extends StatelessWidget {
  final Function onTap;
  final Widget child;

  WidgetCustomInkWell({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () => onTap(),
      child: child,
    );
  }
}

class CustomInkWell extends StatelessWidget {
  final Function onTap;
  final Function onLongPress;
  final Widget child;

  CustomInkWell({required this.child, required this.onTap, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () => onTap(),
      onLongPress: () => onLongPress(),
      child: child,
    );
  }
}