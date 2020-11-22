import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';
import 'package:church_of_christ/utils/widgets/header_text.dart';
import 'package:church_of_christ/utils/widgets/list_cell.dart';
import 'package:church_of_christ/utils/widgets/radio_cell.dart';
import 'package:church_of_christ/utils/widgets/dialog_round.dart';

class SettingsScreen extends StatefulWidget{
  const SettingsScreen({
    Key key,
  }) : super(key:key);

  @override
  State createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen>{
  Themes _themeIndex;
  
  @override
  void initState() {  
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return _handleSettings(context);
  }

  Widget _handleSettings(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ListView( 
            children: <Widget>[
              HeaderText(text:"Usuarios"),
              _geUserRow(), 
              Separator.divider(indent: 72),
              HeaderText(text:"Artistas"),
              _getAuthorsRow(),
              Separator.divider(indent: 72),
              HeaderText(text:"General"),
              _getAppearanceRow(context),
              ListCell.icon(
                icon: Icons.info,
                title: "Información",
                subtitle: "Sobre la app",
                trailing: Icon(Icons.chevron_right),
                onTap: (){
                  Navigator.of(context).pushNamed("/about");
                },
               )
            ],
          ),
        ),
      ),
    );
  }

  Widget _geUserRow(){
    return ListCell.icon(
      icon: Icons.person, 
      title: "Usuario", 
      subtitle: "Registrate o inicia sesión",
      trailing: Icon(Icons.chevron_right),
      onTap: (){
        //TODO make a user screen for login or register 
      },
    );
  }

  Widget _getAuthorsRow(){
    return ListCell.icon(
      icon: Icons.person_pin_circle,
      title: "Artistas",
      subtitle: "Ver a los artistas del acapella style",
      trailing: Icon(Icons.chevron_right),
      onTap: (){
        //TODO make a process to go a screen authors
      },
    );
  }

  Widget _getAppearanceRow(BuildContext context){
    return ListCell.icon(
      icon: Icons.palette, 
      title: "Apariencia", 
      subtitle: "eligue entre la luz y la oscuridad",
      trailing: Icon(Icons.chevron_right),
      onTap: () => showDialog(
          context: context, 
          builder: (context) => RoundDialog(
            title: "Apariencia",
            children: <Widget>[
              RadioCell<Themes>(
                title: "Tema oscuro",
                groupValue: _themeIndex,
                value: Themes.dark,
                onChanged: (value){
                  print("-->valor\n");
                  print(value);
                },
              ),
              RadioCell<Themes>(
                title: "Tema claro",
                groupValue: _themeIndex,
                value: Themes.light,
                onChanged: (value){
                  print("-->valor\n");
                  print(value);
                },
              )
            ],
          ),
      ),
    );
  }

}
