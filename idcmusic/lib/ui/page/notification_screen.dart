import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:church_of_christ/ui/widgets/card_notification.dart';
import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class NotificationScreen extends StatelessWidget{
  final String argumento;

  NotificationScreen({
    this.argumento
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: SafeArea(
        child: Column(          
          children: <Widget>[
            const SizedBox(height: 10.0,),
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              children: <Widget>[
                AppBarCarrousel(title: "Notificaciones", onPressed: (){
                  print("fuck here");
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (Route<dynamic> route) => false
                  );
                }), 
                CardNotification(
                  tTitle: argumento.split("&nbsp")[0].toString(),
                  tContent: argumento.split("&nbsp")[1].toString(),                
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
