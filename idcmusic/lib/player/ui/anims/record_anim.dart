import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class RotateRecord extends AnimatedWidget {
  final Song song;
  final VoidCallback onTap;
  RotateRecord({
    Key key, this.song, Animation<double> animation, this.onTap
  }): super(key: key, listenable: animation);

  Widget build(BuildContext context){
    final Animation<double> animation = listenable;

    return GestureDetector(
      onTap: ()=> onTap(),
      child: Container(
        height: 45.0,
        width: 45.0,
        child: RotationTransition(
          turns: animation,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    (song != null && song.path_image != null)
                        ? song.path_image
                        : Utils.randomUrl()
                )
              )
            ),
          ),
        ),
      ),
    );
  }
}