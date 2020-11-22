import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioTrackWidget extends StatelessWidget{
  final AudioPlayerModel audioPlayerModel;

  const AudioTrackWidget({Key key, @required this.audioPlayerModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: setLeading(),
      title: setTitle(),
      subtitle: setSubtitle(),
      trailing: IconButton(
        icon: setIcon(),
        onPressed: setCallback(context),
      ),
    );
  }

  Widget setIcon(){
    if(audioPlayerModel.isPlaying)
      return Icon(Icons.pause);
    else
      return Icon(Icons.play_arrow);
  }

  Widget setLeading(){
    return  Utils.image(audioPlayerModel.audio.metas.image.path, height: 140.0, width: 180.0, fit: BoxFit.cover);
  }

  Widget setTitle(){
    return Text(audioPlayerModel.audio.metas.title);
  }

  Widget setSubtitle(){
    return Text(audioPlayerModel.audio.metas.artist);  
  }

  Function setCallback(BuildContext context){
    if(audioPlayerModel.isPlaying)
      return () {
        BlocProvider.of<AudioPlayerBloc>(context)
            .add(TriggeredPauseAudio(audioPlayerModel));
      };
    else 
      return (){
        BlocProvider.of<AudioPlayerBloc>(context)
          .add(TriggeredPlayAudio(audioPlayerModel));
      };
  }
}