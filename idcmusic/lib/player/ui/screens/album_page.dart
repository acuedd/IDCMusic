import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/bloc/bloc/AudioCurrentBloc.dart';
import 'package:church_of_christ/bloc/bloc/SongAlbumBloc.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/player/ui/widgets/for_you_carousel.dart';
import 'package:church_of_christ/player/ui/widgets/songItem.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/utils/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';

class AlbumPage extends StatefulWidget{
  final Collection album;
  final int index;

  AlbumPage({this.album, this.index});

  @override
  _AlbumPage createState() => _AlbumPage();
}

class _AlbumPage extends State<AlbumPage>{

  SongAlbumBloc idcBloc;

  @override
  void initState() {
    super.initState();
    idcBloc =  BlocProvider.of<SongAlbumBloc>(context);    
  }

  List<Audio> convertListSongToAudioModel(playlist){
    List<Audio> listAudio = List();
    
    for(var i =0; i< playlist.length; i++){
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

  @override
  Widget build(BuildContext context) {
    idcBloc.add(InitialEvent());
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          AppBarCarrousel(title: "",),
          Expanded(
            child: ListView(  
              children: <Widget>[
                Center( 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                      height: 180.0,
                      width: 180.0,
                      image: CachedNetworkImageProvider(widget.album.path_image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Center( 
                  child: Text(  
                    widget.album.fullname,
                    style: GetTextStyle.M(context),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          
                        },
                        child: Container( 
                        height: 50,
                        margin: EdgeInsets.only(top: 20, bottom: 20, right: 150, left: 150),
                        decoration: BoxDecoration(  
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: Theme.of(context).accentColor, width: 1),
                        ),
                        child: Row( 
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon( 
                              Icons.play_arrow, 
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 5,),
                            Text( 
                              "Play",
                              style: TextStyle(color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      )),
                    ),                    
                  ]
                ),
              ],
            ),
          ),
          Expanded(  
            child: BlocBuilder<SongAlbumBloc, RequestState>(
                builder: (context, state){
                  if(state is RequestEmpty){
                    var idAlbum = int.parse(widget.album.id);
                    idcBloc.add(FetchSongByAlbum(idAlbum));
                  }
                  else if( state is RequestError){
                      return Center(
                        child: Text("Error",
                          style: TextStyle( fontFamily: "Nunito", fontSize: 17.0),
                        ),
                      );
                  }
                  else if( state is RequestLoaded){                          
                    SongModel songModel = SongModel.fromJson(state.response);
                    List<Audio> currentList = convertListSongToAudioModel(songModel.songs);
                    return drawListSong(currentList);
                  }
                  else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }                                              
                  return Container();
                }
              ),
          ),
        ]),
      ),
    );    
  }

  Widget drawListSong(List<Audio> currentList){
    BlocProvider.of<AudioCurrentBloc>(context).add(AudioSetPlaylist(0, currentList, currentList[0]));
    return ListView.builder(
      shrinkWrap: true,
        physics: new NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: currentList.length,
        itemBuilder: (BuildContext context, int index){
          Audio dataSong = currentList[index];
          return songItem(index, dataSong, currentList);
        }
    );                          
  }
}