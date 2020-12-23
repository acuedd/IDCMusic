import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/config/storage_manager.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'model/theme_model.dart';

void main() async{
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
      runApp(MyApp());
    });
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(create: (context) => ThemeModel()),
        ChangeNotifierProvider<FavoriteModel>(create: (context) => FavoriteModel()),
        ChangeNotifierProvider<DownloadModel>(create: (context) => DownloadModel()),
        ChangeNotifierProvider<SongModel>(create: (context) => SongModel()),
      ],
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child){
          return RefreshConfiguration(
            hideFooterWhenNotFull: true,
            child: MaterialApp(
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