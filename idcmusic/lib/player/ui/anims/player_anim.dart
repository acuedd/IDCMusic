import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/bloc/AudioPlayerBloc.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/features/AudioPlayerState.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:church_of_christ/utils/functions.dart';
import "package:flutter/material.dart";
import "package:flutter/animation.dart";
import 'package:cached_network_image/cached_network_image.dart';

class RotatePlayer extends AnimatedWidget{
  final VoidCallback onTap;
  final Audio model;

  RotatePlayer({Key key, Animation<double> animation, this.model,this.onTap})
    :super(key:key, listenable: animation);

    @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return GestureDetector(
      onTap: (){},
      child: RotationTransition(
        turns: animation,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    (model != null && model.metas.image.path != null)
                    ? model.metas.image.path
                    : Utils.randomUrl()
                ),
              )
            ),
          ),
        ),
    );
  }
}