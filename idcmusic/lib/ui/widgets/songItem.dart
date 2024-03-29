

import 'dart:io';

import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SongItem extends StatelessWidget{
  final Song song; 
  final int index;
  final List<Song> songs;
  final bool notShowImage;

  const SongItem({this.song, this.songs, this.index = 0, this.notShowImage = false });

  Widget _buildSongItem(BuildContext context){
    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    int showIndex = (index == 0)?index+1:index;
    
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,        
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[          
          Expanded(
            child: InkWell( 
              onTap: (){
                if(null != song.url){
                  SongModel songModel = Provider.of(context, listen: false);
                  songModel.setSongs(songs, context);
                  songModel.setCurrentIndex(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayPage(
                        nowPlay: true,
                      ),
                    ),
                  );
                }
              },
              child: Row(                
                children: [
                  (notShowImage)
                    ? ClipRRect( 
                        borderRadius: BorderRadius.circular(12.0),
                        child: Container( 
                          decoration: BoxDecoration( 
                            color: Theme.of(context).accentColor.withAlpha(30), 
                          ),
                          width: 50,
                          height: 50,
                          child: Center( 
                            child: Text( '$showIndex', 
                              style: TextStyle( 
                                color: Theme.of(context).accentColor, 
                              ),
                            ),
                          ),
                        ),
                      )
                    : Stack( 
                      children: <Widget>[
                        Container( 
                          height: 50.0,
                          width: 50.0,
                          child: ClipRRect( 
                            borderRadius: BorderRadius.circular(12.0),
                            child: Utils.image(song.pic, fit: BoxFit.cover)
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
                            song.title, 
                            style: GetTextStyle.M(context),
                          ), 
                          SizedBox(height: 8.0,),
                          Text( 
                            song.author, 
                            style: GetTextStyle.S(context),
                          )
                        ],
                      ),
                    ),  
                ],
              ),
            ),
          ),
                 
          IconButton(
            onPressed: () => favoriteModel.collect(song),
            icon: song.url == null
                  ? Icon(
                      Icons.favorite_border,
                      color: Colors.grey,
                      size: 20.0,
                    )
                  : favoriteModel.isCollect(song)
                      ? Icon(
                          Icons.favorite,
                          color: Theme.of(context).accentColor,
                          size: 20.0,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 20.0,
                        ),
          ),
          if(!Platform.isIOS)
            IconButton(
              onPressed: () async{
                var status = await Permission.storage.request();
                if (status.isGranted) {
                  await downloadModel.download(song);
                }
                else{
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => CupertinoAlertDialog(
                          title: Text('Permiso de almacenamiento'),
                          content: Text(
                              'El app necesita permiso para poder guardar las canciones descargadas en el almacenamiento del dispositivo.'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('Deny'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            CupertinoDialogAction(
                              child: Text('Settings'),
                              onPressed: () => openAppSettings(),
                            ),
                          ],
                        )
                    );
                }       
              }, 
              icon: downloadModel.isDownload(song)
                ? Icon(
                Icons.cloud_done,
                color: Theme.of(context).accentColor,
                size: 20.0,
                )
                    : Icon(
                Icons.cloud_download,
                size: 20.0,
                )
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongItem(context);
  }
}