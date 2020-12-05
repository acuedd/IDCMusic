import 'package:church_of_christ/bloc/bloc/AlbumBloc.dart';
import 'package:church_of_christ/bloc/bloc/AudioCurrentBloc.dart';
import 'package:church_of_christ/bloc/bloc/ChangeLogBloc.dart';
import 'package:church_of_christ/bloc/bloc/SongAlbumBloc.dart';
import 'package:church_of_christ/bloc/bloc/theme_change_bloc.dart';
import 'package:church_of_christ/bloc/repository/AudioPlayerRepository.dart';
import 'package:church_of_christ/bloc/repository/InMemoryAudioPlayerRepository.dart';
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/theme_change_event.dart';
import 'package:church_of_christ/player/models/AudioPlayerModelFactory.dart';
import 'package:church_of_christ/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:church_of_christ/bloc/bloc/idc_bloc.dart';
import 'package:church_of_christ/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generals/features/theme_change_state.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("transicion blockobserver $transition\n");
    super.onTransition(bloc, transition);
  }
}

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //print(notification.audioId);
    return true;
  });

  Bloc.observer = SimpleBlocObserver();
  initializeDateFormatting().then((_) => runApp(CherryApp()));
}

class CherryApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CherryApp> {
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  _MyAppState();

  void initState() {
    super.initState();  
  }


  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AudioPlayerRepository>(
              create: (context) => InMemoryAudioPlayerRepository(
                  audioPlayerModels: AudioPlayerModelFactory.getAudioPlayerModels()
              ),
          ), 
          RepositoryProvider<IDCRepository>(
            create: (context) => IDCRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [          
            BlocProvider(
              create: (BuildContext context) => ThemeBloc(repository: RepositoryProvider.of<IDCRepository>(context), ),
            ),
            BlocProvider<AudioCurrentBloc>(
              create: (BuildContext context) => AudioCurrentBloc(
                assetsAudioPlayer: AssetsAudioPlayer.newPlayer(),
                audioPlayerRepository: RepositoryProvider.of<AudioPlayerRepository>(context)
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => IDCBloc(
                repository: RepositoryProvider.of<IDCRepository>(context)
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => AlbumBloc(
                repository: RepositoryProvider.of<IDCRepository>(context)
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => SongAlbumBloc(
                repository: RepositoryProvider.of<IDCRepository>(context)
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => ChangeLogBloc(
                repository: RepositoryProvider.of<IDCRepository>(context)
              ),
            ),
          ],
          child: BlocBuilder<ThemeBloc, ThState>(
            builder:(context, state){               
              if(state is ThemeStateInitial){
                BlocProvider.of<ThemeBloc>(context).add(ThemeGet());
              }
              if(state is ThemeState){
                return MaterialApp(
                  navigatorKey: navigatorKey,
                  title: 'IDC Music',
                  initialRoute: RouteName.splash,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RouteIDC.generateRoute,
                  theme: state.themeData,
                  builder: (context, child){
                    return MediaQuery(
                      child: child,
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    );
                  },
                );
              }
              return MaterialApp(
                navigatorKey: navigatorKey,
                title: 'IDC Music',
                initialRoute: RouteName.splash,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: RouteIDC.generateRoute,
                theme: appThemeData[AppTheme.lightTheme],
                builder: (context, child){
                  return MediaQuery(
                    child: child,
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  );
                },
              );
            }
          ),
        ),
      ),
    );
  }

  
}

