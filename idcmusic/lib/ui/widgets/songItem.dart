

import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:provider/provider.dart';

class SongItem extends StatelessWidget{
  final Song song; 
  final int index;

  const SongItem({this.song, this.index = 0});

  Widget _buildSongItem(BuildContext context){
    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    
    return Padding( 
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row( 
        children: <Widget>[
          (this.index > 0)
          ? ClipRRect( 
              borderRadius: BorderRadius.circular(12.0),
              child: Container( 
                decoration: BoxDecoration( 
                  color: Theme.of(context).accentColor.withAlpha(30), 
                ),
                width: 50,
                height: 50,
                child: Center( 
                  child: Text( '$index', 
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
          IconButton(
            onPressed: () => downloadModel.download(song),
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongItem(context);
  }
}