import 'package:flutter/material.dart';

/// Basic screen, which includes an [AppBar] widget.
/// Used when the desired page doesn't have slivers or reloading.
class BlanckPage extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget> actions;
  final scafoldKey;
  

  const BlanckPage({
    this.title,
    @required this.body,
    this.actions,
    this.scafoldKey,
  });

  factory BlanckPage.offTitle({
    @required Widget body,
    List<Widget> actions,
}){
    return BlanckPage(
      title: "",
      actions: actions,
      body: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(        
        title: Text(
          title,
          style: TextStyle(fontFamily: 'Lato'),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
    );
  }
}
