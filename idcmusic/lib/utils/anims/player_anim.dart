
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/utils/functions.dart';
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
        child: Center( 
          child: Container( 
            width: MediaQuery.of(context).size.width * screenAspectRatio,
            child: ClipRRect( 
              borderRadius: BorderRadius.circular(30.0),
              child: Container(child: Utils.image(songModel.currentSong.pic),),
            ),
          ),
        ),                       
      ),
    );
  }
}