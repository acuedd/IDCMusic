import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlayerState extends Equatable{
  const AudioPlayerState();
}

class AudioPlayerInitial extends AudioPlayerState{
  const AudioPlayerInitial();

  @override
  List<Object> get props => [];
}

class AudioPlayerReady extends AudioPlayerState{
  final List<Audio> entityList;
  final int indexSong;
  //final 
  const AudioPlayerReady(this.indexSong, this.entityList);

  @override
  List<Object> get props => [indexSong,entityList];
}

class AudioPlayerPlaying extends AudioPlayerState{
  final List<Audio> entityList;
  final Audio playingEntity;
  final int indexSong;
  final bool isPlaying;
  final Duration duration;
  final Duration currenpos;

  const AudioPlayerPlaying(this.indexSong,this.playingEntity, this.entityList, 
        this.isPlaying, this.duration, this.currenpos);

  @override
  List<Object> get props => [indexSong, playingEntity, entityList, isPlaying, duration, currenpos];
}

class AudioPlayerPaused extends AudioPlayerState{
  final List<Audio> entityList;
  final Audio playingEntity;
  final int indexSong;
  final bool isPlaying;
  final Duration duration;
  final Duration currenpos;

  const AudioPlayerPaused(this.indexSong,this.playingEntity, this.entityList, 
        this.isPlaying, this.duration, this.currenpos);

  @override
  List<Object> get props => [indexSong, playingEntity, entityList, isPlaying, duration, currenpos];
}

class AudioPlayerFailure extends AudioPlayerState{
  final String error;
  const AudioPlayerFailure(this.error);

  @override
  List<Object> get props => [error];
}
