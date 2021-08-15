import 'dart:io';

import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/dialog_presentation.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/ui/widgets/header_text.dart';
import 'package:church_of_christ/ui/widgets/list_cell.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:package_info/package_info.dart';
import 'package:row_collection/row_collection.dart';

class AboutScreen extends StatefulWidget{
  @override
  _AboutScreenState createState() => _AboutScreenState();  
}

class _AboutScreenState extends State<AboutScreen>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PackageInfo _packageInfo = PackageInfo( 
    version: "Unknown",
    buildNumber: "Unknown",
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<Null> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }
  

  @override
  Widget build(BuildContext context) {    
    return Scaffold( 
      body: SafeArea( 
        child: Column( 
          children: <Widget>[
            AppBarCarrousel(title: "Información"),
            Expanded( 
              child: ListView( children: <Widget>[
                HeaderText(text: "Sobre la app"), 
                ListCell.icon( 
                  context: context,
                  icon: Icons.info,
                  trailing: Icon(Icons.chevron_right),
                  title: "Versión ${_packageInfo.version}",
                  subtitle: "Echa un vistazo a los nuevos cambios",
                  onTap: () => Navigator.of(context).pushNamed("/changelog"),
                ), 
                Separator.divider(indent: 72),
                ListCell.icon( 
                  context: context,
                  icon: Icons.star,
                  trailing: Icon(Icons.chevron_right),
                  title: "¿Disfrutando de la app?",
                  subtitle: "Deja tu experiencia de tienda",
                  onTap: () async =>{
                    if(Platform.isAndroid){
                        await FlutterWebBrowser.openWebPage(
                          url: Url.playStore,
                          customTabsOptions: CustomTabsOptions(
                            toolbarColor: Theme.of(context).primaryColor,
                            secondaryToolbarColor: Theme.of(context).accentColor
                          )
                        ),
                      }
                      else{
                        await FlutterWebBrowser.openWebPage(
                          url: Url.appStore,
                          safariVCOptions: SafariViewControllerOptions(
                            barCollapsingEnabled: true,
                            preferredBarTintColor: Theme.of(context).accentColor,
                          ),
                        ),
                      }
                  },
                ),
                HeaderText(text: "Autor"),
                ListCell.icon(
                  context: context,
                    icon: Icons.person,
                    trailing: Icon(Icons.chevron_right),
                    title: "Aplicaciones libres",
                    subtitle: "Bien diseñadas y hechas con amor",
                    onTap: () async => {
                      if(Platform.isAndroid){
                        await FlutterWebBrowser.openWebPage(
                          url: Url.authorStore,
                          customTabsOptions: CustomTabsOptions(
                            toolbarColor: Theme.of(context).primaryColor,
                            secondaryToolbarColor: Theme.of(context).accentColor
                          )
                        ),
                      }
                      else{
                        await FlutterWebBrowser.openWebPage(
                          url: Url.authorAppStore,
                          safariVCOptions: SafariViewControllerOptions(
                            barCollapsingEnabled: true,
                            preferredBarTintColor: Theme.of(context).accentColor,
                          ),
                        ),
                      }
                    }
                  ),
                  ListCell.icon(
                    context: context,
                    icon: Icons.cake,
                    trailing: Icon(Icons.chevron_right),
                    title: "Apoya la iniciativa",
                    subtitle: "Escríbeme en whatsapp",
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => PresentationDialog.about(context, ()async{
                        Navigator.pop(context, true);
                        await FlutterWebBrowser.openWebPage(
                          url: Url.apiContactMe
                        );
                      },
                      "Contáctame"
                      ),
                    ),
                  ),
                  Separator.divider(indent: 72),
                  ListCell.icon(
                    context: context,
                    icon: Icons.mail,
                    trailing: Icon(Icons.chevron_right),
                    title: "Envíame un correo",
                    subtitle: "Reporta fallos o solicita nuevas funciones",
                    onTap: () async {
                      if (Platform.isIOS) {
                        final bool canSend = await FlutterMailer.canSendMail();
                        if (!canSend) {
                          const SnackBar snackbar =
                              const SnackBar(content: Text('No hay aplicación de email disponible', textAlign: TextAlign.center,),);
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                          return;
                        }
                      }
                      await FlutterMailer.send(MailOptions(
                        isHTML: true,
                        subject: Url.authorEmail['subject'],
                        recipients: [Url.authorEmail['address']],
                      ));
                    
                    },
                  ),
                  HeaderText(text: "Agradecimientos"),
                  ListCell.icon(
                    context: context,
                    icon: Icons.favorite,
                    trailing: Icon(Icons.chevron_right),
                    title: "Iglesia de Cristo GT",
                    subtitle: "Iglesia de Cristo en Mixco Nueva Jerusalén",
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => RoundDialog(
                        title: "Agradecimiento",
                        children: [
                          Padding(padding: EdgeInsets.only(left: 25, right: 25),
                            child: Text(Url.strAcknoledgementChurch, 
                            textAlign: TextAlign.justify,
                            style: GetTextStyle.subtitle1(context)),
                          ),
                        ],
                      ),
                    ),
                  ),                  
                  Separator.divider(indent: 72),
                  ListCell.icon(
                    context: context,
                    icon: Icons.favorite,
                    trailing: Icon(Icons.chevron_right),
                    title: "Gratitud",
                    subtitle: "A personas especiales",
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => RoundDialog(
                        title: "Con gratitud",
                        children: [
                          Padding(padding: EdgeInsets.only(left: 25, right: 25),
                            child: Text(Url.strAcknoledgement, 
                            textAlign: TextAlign.justify,
                            style: GetTextStyle.subtitle1(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Separator.divider(indent: 72),
                  ListCell.icon(
                    context: context,
                    icon: Icons.thumb_up,
                    trailing: Icon(Icons.chevron_right),
                    title: "Gracias",
                    subtitle: "A todos los artistas",
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => RoundDialog(
                        title: "GRACIAS",
                        children: [
                          Padding(padding: EdgeInsets.only(left: 25, right: 25),
                            child: Text(Url.thanksToArtist, 
                            textAlign: TextAlign.justify,
                            style: GetTextStyle.subtitle1(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}