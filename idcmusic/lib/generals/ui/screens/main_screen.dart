import 'package:church_of_christ/generals/ui/screens/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot prefs){
        if(prefs.connectionState != ConnectionState.none){
          try{
            String isLogged = prefs.data.getString("logged");
            //TODO something when the user is logged

            return TabNavigator();
          }
          catch(Error){
            return TabNavigator();
          }
        }
        return Container();
      },
    );
  }
}