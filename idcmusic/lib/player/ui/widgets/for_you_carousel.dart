import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/player/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class ForYouCarousel extends StatefulWidget {
  final List<Song> forYou;

  ForYouCarousel(this.forYou);
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel> {

  List<Audio> currentList;
  
  @override
  Widget build(BuildContext context) {
    currentList = convertListSongToAudioModel(widget.forYou);

    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Para ti",
              style: GetTextStyle.XL(context),
            ),
            /*GestureDetector(
              onTap: ()=>{
                print("view all songs"),
              },
              child: Text("Ver todos",
                style: GetTextStyle.SM(context),
              ),
            ),*/
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: currentList.length,
          itemBuilder: (BuildContext context, int index){
            Audio dataSong = currentList[index];
            return songItem(index, dataSong, currentList);
          }
      ),
    ]);
  }


  List<Audio> convertListSongToAudioModel(playlist){
    List<Audio> listAudio = List();
    
    for(var i =0; i<playlist.length; i++){
      Song song = playlist[i];
      AudioPlayerModel item = convertSongToAudioModel(song);
      listAudio.add(item.audio);
    }
    return listAudio;
  }

  AudioPlayerModel convertSongToAudioModel(Song song){
    return AudioPlayerModel(
          isPlaying: false, 
          id: song.id_resource,
          audio: Audio.network(
            song.path, 
            metas: Metas(
              id: song.id_resource, 
              title: song.title_resource, 
              artist: song.fullname, 
              album: song.name_collection, 
              image: MetasImage.network(song.path_image)
            )
          )
        );
  }

}
