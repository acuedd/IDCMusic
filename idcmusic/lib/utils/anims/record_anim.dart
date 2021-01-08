

import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RotateRecord extends AnimatedWidget{

  RotateRecord({Key key, Animation<double> animation})
    : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable; 
    SongModel songModel = Provider.of(context); 
    return GestureDetector( 
      onTap: (){
        if(songModel.songs != null){
          /*Navigator.push( context,
            MaterialPageRoute(builder: (_) => PlayPage(nowPlay: false));
          );*/
        }
      },
      child: Container( 
        height: 45.0,
        width: 45.0,
        child: RotationTransition( 
          turns: animation,
          child: Container( 
            decoration: BoxDecoration( 
              shape: BoxShape.circle, 
              image: DecorationImage( 
                image: CachedNetworkImageProvider(songModel.songs != null
                  ? songModel.currentSong.pic
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