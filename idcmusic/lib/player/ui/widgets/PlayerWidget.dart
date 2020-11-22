import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/features/AudioPlayerState.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerWidget extends StatelessWidget{
  const PlayerWidget({ Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state){
        if(state is AudioPlayerInitial || state is AudioPlayerReady){
          return SizedBox.shrink();
        }
        else if(state is AudioPlayerPlaying){
          return _showPlayer(context, state.playingEntity);
        }
        else{
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _showPlayer(BuildContext context, AudioPlayerModel model){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            color: Colors.grey.shade200,
            child: ListTile(
              leading: setLeading(model),
              title: setTitle(model),
              subtitle: setSubtitle(model),
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              trailing: IconButton(
                icon: setIcon(model),
                onPressed: setCallback(context, model),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setIcon(AudioPlayerModel model){
    if(model.isPlaying)
      return Icon(Icons.pause);
    else 
      return Icon(Icons.play_arrow);
  }

  Widget setLeading(AudioPlayerModel model){
    return Utils.image(model.audio.metas.image.path);
  }

  Widget setTitle(AudioPlayerModel model){
    return Text(model.audio.metas.title);    
  }

  Widget setSubtitle(AudioPlayerModel model){
    return Text(model.audio.metas.artist);
  }

  Function setCallback(BuildContext context, AudioPlayerModel model){
    if(model.isPlaying)
      return (){
        BlocProvider.of<AudioPlayerBloc>(context)
          .add(TriggeredPauseAudio(model));
      };
    else 
      return (){
        BlocProvider.of<AudioPlayerBloc>(context)
          .add(TriggeredPlayAudio(model));
      };
  }
}