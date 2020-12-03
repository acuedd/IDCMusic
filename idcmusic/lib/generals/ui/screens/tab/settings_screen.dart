import 'dart:math';

import 'package:church_of_christ/bloc/bloc/theme_change_bloc.dart';
import 'package:church_of_christ/generals/features/theme_change_event.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _SettingsScreenState extends State<SettingsScreen> with AutomaticKeepAliveClientMixin{
  Themes _themeIndex;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {  
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return _handleOptionWidget(context);
  }

  Widget _handleOptionWidget(BuildContext context){
    super.build(context);
    return Scaffold(
      body: SafeArea( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: HeaderText(text:"General"),              
            ), 
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  listOptionWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class listOptionWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).accentColor;

    return ListTileTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SliverList(
        delegate: SliverChildListDelegate([
          ListTile(
            title: Text("Modo oscuro",
              style: GetTextStyle.L(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: (){
                if(Theme.of(context).brightness == Brightness.dark){
                  BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.lightTheme, color: iconColor));
                }
                else{
                  BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.darkTheme,color: iconColor));
                }
            },
            leading: Transform.rotate(
              angle: -pi,
              child: Icon( 
                Theme.of(context).brightness == Brightness.light
                    ? Icons.brightness_5
                    : Icons.brightness_2,
                color: iconColor,
              ),              
            ),
            trailing: CupertinoSwitch(
              activeColor: Theme.of(context).accentColor,
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value){
                  print(value);
                  if(value){
                      BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.darkTheme, color: iconColor));
                  }
                  else{
                    BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.lightTheme, color: iconColor));
                  }
              },
            ),
          ),
          SettingThemeWidget(),
          ListTile(
            title: Text("Información del app", 
              style: GetTextStyle.L(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: (){
              Navigator.of(context).pushNamed("/about");
            },
            leading: Icon(
              Icons.info,
              color: iconColor,
            ),
            trailing: IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: (){
                Navigator.of(context).pushNamed("/about");
              },
            ),
          ),          
        ]),
      ),
    );
  }
}

class SettingThemeWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Tema",style: GetTextStyle.L(context),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: Icon( 
        Icons.color_lens, 
        color: Theme.of(context).accentColor,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap( 
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...Colors.primaries.map((color){
                return Material( 
                  color: color, 
                  child: InkWell( 
                    onTap: (){
                      if(Theme.of(context).brightness == Brightness.dark){
                        BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.darkTheme, color: color));
                      }
                      else{
                        BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(theme: AppTheme.lightTheme,color: color));
                      }
                    },
                    child: Container( 
                      width: 40, height: 40,
                    ),
                  ),
                );
              }).toList(),              
            ],
          ),
        ),
      ],
    );
  }
}