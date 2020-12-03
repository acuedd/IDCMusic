import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/bloc/AudioCurrentBloc.dart';
import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/player/ui/screens/player_page.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/widgets/header_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class songItem extends StatelessWidget{
  final Audio song;
  final List<Audio> playlist;
  final int indexSong;

  songItem(this.indexSong, this.song, this.playlist );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){        
        //BlocProvider.of<AudioCurrentBloc>(context).add(TriggeredStopAudio());
        Navigator.push(context, MaterialPageRoute(          
          builder: (_) => PlayerPage(
            nowPlay: true,
            song: song,
            indexSong: indexSong,
            playlist: playlist,
          )        
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      song.metas.image.path, 
                      fit: BoxFit.cover,
                    ),                    
                  ),
                ), 
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: Icon(
                    Icons.play_circle_filled, 
                    color: Colors.white.withOpacity(0.7),
                    size: 42.0,
                  ),
                ), 
              ],              
            ),
            SizedBox(width: 20.0,),
            Expanded(              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.metas.title,
                    style: GetTextStyle.M(context),
                  ),
                  SizedBox(height: 8.0,),
                  Text(
                    song.metas.artist,
                    style: GetTextStyle.S(context),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () => print("press favorite"),
              icon: Icon(
                Icons.favorite_border,
                color: Theme.of(context).textTheme.caption.color.withOpacity(0.3),
                size: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}