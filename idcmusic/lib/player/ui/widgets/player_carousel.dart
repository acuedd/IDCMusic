import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/bloc/AudioCurrentBloc.dart';
import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Player extends StatefulWidget{
  final Audio songData; 
  final List<Audio> playlist;
  final int indexSong;
  final bool isPlaying;
  final Duration duration;
  
  final double volume;
  final Color color;

  Player({
    Key key,
    @required this.songData, 
    @required this.playlist, 
    @required this.indexSong,
    this.isPlaying,
    this.duration,
    this.volume: 1.0, 
    this.color: Colors.white,
  });

  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  Duration _duration;
  Duration _position;

  @override
  Widget build(BuildContext context) {
    _duration = widget.duration;

    return Column(
      children: _controllers(context),
    );
  }

  List<Widget> _controllers(BuildContext context){
    return [
      Visibility(
        visible: true,
        child: new Slider(
          onChangeStart:(v){

          }, 
          onChanged: (v){

          }, 
          onChangeEnd: (v){

          },
          value: 0.0,
          activeColor: Theme.of(context).accentColor,
        ),
      ),
      Visibility(
        visible: true,
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _timer(context),
        ),        
      ), 
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: new Row(
          crossAxisAlignment:  CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
              visible: true,
              child: IconButton(
                onPressed: (){ },
                icon: Icon(
                  Icons.list, 
                  size: 25.0,
                  color: Colors.grey,
                ),
              ),
            ),
            IconButton(
              onPressed: (){ 
                BlocProvider.of<AudioCurrentBloc>(context)
                      .add(TriggeredPrevAudio());
              },
              icon: Icon(
                Icons.fast_rewind, 
                size: 25.0,
                color: Theme.of(context).accentColor,
              ),
            ), 
            ClipOval(
              child: Container( 
                color: Theme.of(context).accentColor.withAlpha(30),
                width: 70.0,
                height: 70.0,
                child: IconButton(
                  onPressed: (){                    
                    if(widget.isPlaying){
                      BlocProvider.of<AudioCurrentBloc>(context)
                        .add(TriggeredPauseAudio(widget.indexSong, widget.songData));
                    }
                    else{
                      BlocProvider.of<AudioCurrentBloc>(context)
                        .add(TriggeredPlayAudio(widget.indexSong ,widget.songData));
                    }
                  },
                  icon: Icon(                    
                    widget.isPlaying ? Icons.pause : Icons.play_arrow, 
                    size: 30.0,
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),             
            IconButton(
              onPressed: (){
                BlocProvider.of<AudioCurrentBloc>(context)
                      .add(TriggeredNextAudio());
               },
              icon: Icon(
                Icons.fast_forward, 
                size: 25.0,
                color: Theme.of(context).accentColor,
              ),
            ),
            Visibility(
              visible: true,
              child: IconButton(
                onPressed: (){ },
                icon: Icon(
                  Icons.repeat, 
                  size: 25.0,
                  color: Colors.grey,
                ),
              ),
            ),
          ]
        ),
      ),
    ];
  }

  Widget _timer(BuildContext context){
    var style = new TextStyle(
      color: Colors.grey, 
      fontSize: 12,
    );
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        new Text(
          _formatDuration(_position), 
          style: style,
        ), 
        new Text(
          _formatDuration(_duration), 
          style: style,
        ),
      ],
    );
  }

  String _formatDuration(Duration d){
    if(d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = "$minute" + ":" + ((second < 10) ? "0$second" : "$second");
    return format;
  }
}