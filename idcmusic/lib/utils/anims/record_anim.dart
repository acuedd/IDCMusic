

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RotateRecord extends AnimatedWidget{
  String imagePath;
  RotateRecord({Key key, Animation<double> animation, this.imagePath = null})
    : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable; 
    SongModel songModel = Provider.of(context); 
    return GestureDetector( 
      onTap: (){
        if(songModel.songs != null){
          Navigator.push( context,
            MaterialPageRoute(builder: (_) => PlayPage(nowPlay: false)),
          );
        }
      },
      child: Container( 
        height: 75.0,
        width: 75.0,
        child: RotationTransition( 
          turns: animation,
          child: Container( 
            decoration: BoxDecoration( 
              shape: BoxShape.circle, 
              image: DecorationImage( 
                image: CachedNetworkImageProvider(songModel.songs != null
                  ? (imagePath != null)
                    ? imagePath
                    : songModel.currentSong.pic
                  : Utils.randomUrl()
                ),
              )
            ),
          ),
        ),
      ),
    );
  }
}