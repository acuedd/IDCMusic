import 'package:church_of_christ/utils/functions.dart';
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
    /*return Scaffold(  
      key: scafoldKey,
      body: SafeArea(  
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBarCarrousel(title: title,),
            Expanded(  
              child: body,
            ),
          ]
        ),
      ),
    );*/
    
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: GetTextStyle.APPBAR(context),
        ),
        centerTitle: true,
        actions: actions,
      ),
      body: body,
    );
  }
}
