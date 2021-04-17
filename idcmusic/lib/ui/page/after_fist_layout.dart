


import 'package:after_layout/after_layout.dart';
import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/ui/page/welcome_page.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AfterFist extends StatefulWidget{

  @override
  _AfterFist createState() => _AfterFist();
}

class _AfterFist extends State<AfterFist> with AfterLayoutMixin<AfterFist> {

  Future checkFirstSeen() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    bool _seen = (prefs.getBool('seen') ?? false);  
    if (_seen ) {  
      Navigator.of(context).pushReplacementNamed(RouteName.tab);
    } else {  
      await prefs.setBool('seen', true);  
      Navigator.of(context).pushReplacement(  
        new MaterialPageRoute(builder: (context) => new WelcomeScreen()));  
    }  
  }  

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(  
      body: new Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child: Text("Cargando..."),),
            Loader(),
        ]),
      ),  
    );  
  }

}