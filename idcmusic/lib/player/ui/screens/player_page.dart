import "dart:ui";
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/bloc/AudioCurrentBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/features/AudioPlayerState.dart';
import 'package:church_of_christ/player/ui/anims/player_anim.dart';
import 'package:church_of_christ/player/ui/widgets/player_carousel.dart';
import 'package:church_of_christ/utils/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerPage  extends StatefulWidget{
  final bool nowPlay;
  final Audio song;
  final List<Audio> playlist;
  final int indexSong;
  

  PlayerPage({this.nowPlay, this.song, this.indexSong, this.playlist});

  @override
  State<StatefulWidget> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayerPage> with TickerProviderStateMixin{
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);  
  
  AudioCurrentBloc audioBloc;

  @override
  initState() {
    super.initState();
    
    audioBloc = BlocProvider.of<AudioCurrentBloc>(context);
  
    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    animationPlayer =
        new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
    animationPlayer.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controllerPlayer.repeat();
      } else if (status == AnimationStatus.dismissed) {
        controllerPlayer.forward();
      }
    });        
    audioBloc.add(TriggeredStopAudio());          
  }

  @override
  void dispose() {
    controllerPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  
  
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: _builderCurrentPlayer(widget.song)
      ),
    );
  }

  Widget _builderCurrentPlayer(Audio currentModel){
    return BlocBuilder<AudioCurrentBloc, AudioPlayerState>(
        builder: (context, state2){
          if(state2 is AudioPlayerInitial){          
            audioBloc.add(AudioSetPlaylist(widget.indexSong, widget.playlist, widget.song));
          }
          else if(state2 is AudioPlayerReady){
            print("aquí AudioPlayerReady \n");
            Duration timing = Duration(minutes: 0, seconds: 0);
            return _player(context, state2.indexSong ,widget.song, state2.entityList, false, timing);
          }        
          else if(state2 is AudioPlayerPlaying){
            controllerPlayer.forward();
            print("fuck");
            return _player(context, state2.indexSong, state2.playingEntity ,
                    state2.entityList, state2.isPlaying, state2.duration);
          }
          else if(state2 is AudioPlayerPaused){
            print("fuck here paused");
            controllerPlayer.stop(canceled: false);
            return _player(context, state2.indexSong, state2.playingEntity ,
                    state2.entityList, state2.isPlaying, state2.duration);
          }

          return Container();
        },
      );
  }

  Widget _player(BuildContext context, int index, Audio currentSong, 
                List<Audio> currentList, bool isPlaying, Duration duration){
    return Column(
              children: <Widget>[                              
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AppBarCarrousel(title: "",),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05
                            ),
                            RotatePlayer(
                              animation: _commonTween.animate(controllerPlayer),
                              model: currentSong,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ), 
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                  onPressed: (){

                                  },
                                  icon: Icon(
                                    Icons.list,
                                    size: 25.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                            Icons.shuffle,
                                            size: 25.0,
                                            color: Colors.grey,
                                          ),
                                ),
                                IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.favorite,
                                    size: 25.0,
                                    color: Theme.of(context).accentColor
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){},
                                  icon: Icon(
                                    Icons.cloud_download,
                                    size: 25.0,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),    
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02
                            ),
                            Text(
                              currentSong.metas.artist,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01),
                            Text(
                              currentSong.metas.title,
                              style: TextStyle(fontSize: 20.0),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  ),
                  Player(
                    songData: currentSong,
                    playlist: currentList,
                    indexSong: index,
                    isPlaying: isPlaying,
                  ),                
              ]);
  }

}