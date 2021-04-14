
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RotatePlayer extends AnimatedWidget{
  RotatePlayer({ Key key, Animation<double> animation })
    : super(key:key, listenable: animation); 
  
  Widget build(BuildContext context){
    final Animation<double> animation = listenable; 
    SongModel songModel = Provider.of(context, listen: false);
    return GestureDetector( 
      onTap: (){},
      child: RotationTransition( 
        turns: animation,
        child: Container( 
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration( 
            shape: BoxShape.circle, 
            image: DecorationImage( 
              image: CachedNetworkImageProvider(songModel.currentSong.pic), 
            ),
          ),
        ),
      ),
    );
  }
}