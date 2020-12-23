
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundDialog extends StatelessWidget{

  final String title;
  final List<Widget> children;

  const RoundDialog({
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Lato',
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.center,
      ),
      children: children,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}