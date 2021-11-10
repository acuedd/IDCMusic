
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
    
    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 0;
    if(screenHeight>800){
      screenAspectRatio = 0.8;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 0.6;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 0.4;
    }

    return GestureDetector( 
      onTap: (){},
      child: RotationTransition( 
        turns: animation,
        child: Container( 
          width: MediaQuery.of(context).size.width * screenAspectRatio,
          height: MediaQuery.of(context).size.width * screenAspectRatio,
          decoration: BoxDecoration( 
            shape: BoxShape.rectangle, 
            image: DecorationImage( 
              image: CachedNetworkImageProvider(songModel.currentSong.pic), 
            ),
          ),
        ),
      ),
    );
  }
}