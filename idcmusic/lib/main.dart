import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/config/storage_manager.dart';
import 'package:church_of_christ/model/changelog_model.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/service/authenticate.dart';
import 'package:church_of_christ/service/push_notificacions_service.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/theme_model.dart';

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();

   AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    debugPrint("AssetAudioPlayer");
    debugPrint(notification.audioId);
    return true;
  });

  await PushNotificationProvider.initialize();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
      runApp(MyApp());
    });  
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  
  void initState() {
    super.initState();
    PushNotificationProvider.mensajes.listen((argumento) {
      String named; 
      var modulo = argumento.split("&nbsp");
      String push = modulo[2].toString();
      switch(push){
        case "playsong": named = 'playSong'; break;
        default: named = '/notifications'; break;
      }
      if(named=="/notifications"){
        navigatorKey.currentState?.pushNamed('/notifications', arguments: argumento);
      }
      else{
        navigatorKey.currentState?.pushNamed('/notifications', arguments: argumento);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(create: (context) => ThemeModel()),
        ChangeNotifierProvider<FavoriteModel>(create: (context) => FavoriteModel()),
        ChangeNotifierProvider<DownloadModel>(create: (context) => DownloadModel()),
        ChangeNotifierProvider<SongModel>(create: (context) => SongModel()),
        ChangeNotifierProvider<ChangelogModel>(create: (context) => ChangelogModel()),
        ChangeNotifierProvider<Authentication>(create: (context) => Authentication.instance()),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child){
          return RefreshConfiguration(
            hideFooterWhenNotFull: true,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              theme: themeModel.themeData(),
              darkTheme: themeModel.themeData(platformDarkMode: true),
              onGenerateRoute: RouteIDC.generateRoute,
              initialRoute: RouteName.splash,
            ),
          );
        },
      ),
    );
  } 
}