import 'dart:io';
import 'dart:isolate';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/config/storage_manager.dart';
import 'package:church_of_christ/model/changelog_model.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/service/push_notificacions_service.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/theme_model.dart';


final GlobalKey<NavigatorState> navigatorGlobalKey = new GlobalKey<NavigatorState>();

// top level function is never called :-(
void myAlarmNotify() async{
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;

  var sharedPreferences = await SharedPreferences.getInstance();
  int intTimeToSleep = sharedPreferences.getInt("goSleep");  
  String dateSleepSetDate = sharedPreferences.getString("sleepSetTime");  
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  DateTime dateTime = dateFormat.parse(dateSleepSetDate.toString());
  Duration duration = now.difference(dateTime);    
  int intDifferenceTime = duration.inMinutes.floor().toInt();

  print("[$now] TIME TO BED! gotosleep=$intTimeToSleep, timeSetSleep=$dateTime, difference $duration.inMinutes.floor().toInt()");  
  print("TIME TO BED! DIFFERENCE $intDifferenceTime");
  if(intDifferenceTime >= intTimeToSleep){    
      exit(0);
  }
}

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  final int helloAlarmID = 0;  

   AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    debugPrint("AssetAudioPlayer");
    debugPrint(notification.audioId);
    return true;
  });


  await AndroidAlarmManager.periodic(const Duration(seconds: 30), helloAlarmID, myAlarmNotify).then((value) =>  print('Alarm Timer Started = $value'));

  //AssetsAudioPlayer.withId("macapella").stop();

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
  Key key = UniqueKey();

  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {     
      setState(() {
        final pushProvider = new PushNotificationService();
        pushProvider.initialize();
      });
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