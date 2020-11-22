import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/bloc/repository/AudioPlayerRepository.dart';
import 'package:church_of_christ/bloc/repository/InMemoryAudioPlayerRepository.dart';
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/player/models/AudioPlayerModelFactory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:church_of_christ/bloc/bloc/idc_bloc.dart';
import 'package:church_of_christ/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("transicion blockobserver ${transition}");
    super.onTransition(bloc, transition);
  }
}

void main() {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    print(notification.audioId);
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
            BlocProvider<AudioPlayerBloc>(
              create: (BuildContext context) => AudioPlayerBloc(
                assetsAudioPlayer: AssetsAudioPlayer.newPlayer(),
                audioPlayerRepository: RepositoryProvider.of<AudioPlayerRepository>(context)
              ),
            ),
            BlocProvider(
              create: (BuildContext context) => IDCBloc(
                repository: RepositoryProvider.of<IDCRepository>(context)
              ),
            )
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'IDC Music',
            initialRoute: '/',
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteIDC.generateRoute,
            builder: (context, child){
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              );
            },
          ),
        ),
      ),
    );
  }
}

