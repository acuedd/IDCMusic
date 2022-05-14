import 'dart:math';
import 'package:church_of_christ/model/theme_model.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
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
              child: HeaderText(text: "General"),
            ),
            Expanded( 
              child: CustomScrollView( 
                slivers: <Widget>[
                  listOptionWidget(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: Center(
                child: Text(
                  "Hecho con ♥ por Ed Acu 👽",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }  
}

class listOptionWidget extends StatelessWidget{ 
    
  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).colorScheme.secondary; 
    
    return ListTileTheme( 
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SliverList( 
        delegate: SliverChildListDelegate([ 
          ListTile( 
            title: Text("Modo oscuro" , 
              style: GetTextStyle.L(context),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: (){ 
              switchDarkMode(context);
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
              activeColor: Theme.of(context).colorScheme.secondary,
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value){
                switchDarkMode(context);
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

void switchDarkMode(BuildContext context){
  if(MediaQuery.of(context).platformBrightness == Brightness.dark){
    Toast.show("Tienes activado el modo oscuro en tu celular", context, duration: 2, gravity: Toast.BOTTOM);
  }
  else{
    Provider.of<ThemeModel>(context, listen: false).switchTheme(
      useDarkMode: Theme.of(context).brightness == Brightness.light
    );
  }
}

class SettingThemeWidget extends StatelessWidget{
  SettingThemeWidget();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile( 
      title: Text("Tema", style: GetTextStyle.L(context),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      leading: Icon( 
        Icons.color_lens, 
        color: Theme.of(context).colorScheme.secondary,
      ),
      children: <Widget>[
        Padding( 
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap( 
            spacing: 5,
            runSpacing: 5,
            children: <Widget>[
              ...Colors.primaries.map((color) {
                return Material(
                  color: color,
                  child: InkWell(
                    onTap: () {
                      var model = Provider.of<ThemeModel>(context, listen: false);
                      model.switchTheme(color: color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                    ),
                  ),
                );
              }).toList(),
              Material(
                child: InkWell(
                  onTap: () {
                    var model = Provider.of<ThemeModel>(context, listen: false);
                    var brightness = Theme.of(context).brightness;
                    model.switchRandomTheme(brightness: brightness);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).colorScheme.secondary)),
                    width: 40,
                    height: 40,
                    child: Text(
                      "?",
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
