import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';

abstract class AudioPlayerEvent extends Equatable{
  const AudioPlayerEvent();
}

class InitializeAudio extends AudioPlayerEvent{
  const InitializeAudio();

  @override
  List<Object> get props => [];
}

class TriggeredPlayAudio extends AudioPlayerEvent{
  final int indexSong;
  final Audio audioPlayerModel;

  const TriggeredPlayAudio(this.indexSong,this.audioPlayerModel);

  @override
  List<Object> get props => [indexSong,audioPlayerModel];
}

class TriggeredPauseAudio extends AudioPlayerEvent{
  final int indexSong;
  final Audio audioPlayerModel;

  const TriggeredPauseAudio(this.indexSong,this.audioPlayerModel);

  @override
  List<Object> get props => [indexSong,audioPlayerModel];
}

class TriggeredStopAudio extends AudioPlayerEvent{
  const TriggeredStopAudio();

  @override
  List<Object> get props => [];
}

class TriggeredNextAudio extends AudioPlayerEvent{
  const TriggeredNextAudio();

  @override
  List<Object> get props => [];
}

class TriggeredPrevAudio extends AudioPlayerEvent{
  const TriggeredPrevAudio();

  @override
  List<Object> get props => [];
}

class AudioPlayed extends AudioPlayerEvent{

  final AssetsAudioPlayer audioModelMetaId;

  const AudioPlayed(this.audioModelMetaId);

  @override
  List<Object> get props => [audioModelMetaId];
}

class AudioPaused extends AudioPlayerEvent{

  final AssetsAudioPlayer audioModelMetaId;

  const AudioPaused(this.audioModelMetaId);

  @override
  List<Object> get props => [audioModelMetaId];
}

class AudioStopped extends AudioPlayerEvent{

  const AudioStopped();

  @override
  List<Object> get props => [];

}

class AudioSetPlaylist extends AudioPlayerEvent{
  final List<Audio> listAudioPlayerModel;
  final Audio audioPlayerModel;
  final int indexSong;

  const AudioSetPlaylist(this.indexSong, this.listAudioPlayerModel, this.audioPlayerModel);

  @override
  List<Object> get props => [indexSong,listAudioPlayerModel, audioPlayerModel];

  @override
  String toString() => "AudioSetPlaylist { index:$indexSong - updated: $audioPlayerModel}\n";
}