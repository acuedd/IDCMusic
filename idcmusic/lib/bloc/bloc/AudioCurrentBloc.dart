import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/repository/AudioPlayerRepository.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/features/AudioPlayerState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioCurrentBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AssetsAudioPlayer assetsAudioPlayer;
  final AudioPlayerRepository audioPlayerRepository;

  List<StreamSubscription> playerSubscriptions = new List();
  
  AudioCurrentBloc({this.assetsAudioPlayer, this.audioPlayerRepository}) : super(AudioPlayerInitial()){
    playerSubscriptions.add(
        assetsAudioPlayer.playerState.listen((event) {
          _mapPlayerStateToEvent(event);
        }));
  }

  @override
  Future<Function> close(){
    playerSubscriptions.forEach((element) {
      element.cancel();
    });
    return assetsAudioPlayer.dispose();
  }

  @override
  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    
    if(event is InitializeAudio){      
      yield AudioPlayerInitial();
    }

    else if(event is AudioPlayed){
      yield* _mapAudioPlayedToState(event);
    }
    else if(event is AudioPaused){
      yield* _mapAudioPausedToState(event);
    }
    else if(event is AudioStopped){
      yield* _mapAudioStoppedToState();
    }
    else if(event is AudioSetPlaylist){
      yield* _mapAudioSetPlaylistToState(event);
    }
    else if(event is TriggeredStopAudio){
      yield* _mapTriggeredStopAudio(event);
    }
    else if(event is TriggeredPlayAudio){
      yield* _mapTriggeredPlayAudio(event);
    }
    else if(event is TriggeredPauseAudio){
      yield* _mapTriggeredPausedAudio(event);
    }
    else if(event is TriggeredNextAudio){
      yield* _mapTriggeredNextAudio(event);
    }
    else if(event is TriggeredPrevAudio){
      yield* _mapTriggeredPrevAudio(event);
    }

  }

  void _mapPlayerStateToEvent(PlayerState playerState) {
    if(playerState == PlayerState.stop){
      add(AudioStopped());
    }
    else if(playerState == PlayerState.pause){
      add(AudioPaused(assetsAudioPlayer));
    }
    else if(playerState == PlayerState.play){
      add(AudioPlayed(assetsAudioPlayer));
    }
  }

  Stream<AudioPlayerState> _mapAudioSetPlaylistToState(AudioSetPlaylist event) async*{
    final List<Audio> updatedList = event.listAudioPlayerModel;
    await audioPlayerRepository.updateAllModels(updatedList);
    /*if(assetsAudioPlayer.isPlaying.value){
      assetsAudioPlayer.stop();
    }*/

    assetsAudioPlayer.open(
      Playlist(
        audios: updatedList,
      ), 
      autoStart: false,
      showNotification: true,
      respectSilentMode: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      loopMode: LoopMode.playlist
    );
    
    yield AudioPlayerReady(event.indexSong ,updatedList);
  }

  Stream<AudioPlayerState> _mapTriggeredPlayAudio(TriggeredPlayAudio event) async* {
    if (state is AudioPlayerReady) {
      final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
      final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
      final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
      int index = assetsAudioPlayer.current.value.playlist.currentIndex;
      var songDuration = assetsAudioPlayer.current.value.audio.duration;
      var currentPosition = assetsAudioPlayer.currentPosition.value;
      
      await assetsAudioPlayer.playlistPlayAtIndex(event.indexSong);
      yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
    }
    if (state is AudioPlayerPaused) {
      final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
      final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
      final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
      int index = assetsAudioPlayer.current.value.playlist.currentIndex;
      var songDuration = assetsAudioPlayer.current.value.audio.duration;
      var currentPosition = assetsAudioPlayer.currentPosition.value;

      if(event.audioPlayerModel.metas.id == (state as AudioPlayerPaused).playingEntity.metas.id){
        
        await assetsAudioPlayer.play();
        yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
      }
      else{
        await assetsAudioPlayer.playlistPlayAtIndex(event.indexSong);        
        yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
      }      
    }
    if (state is AudioPlayerPlaying) {
      final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
      final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
      final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
      int index = assetsAudioPlayer.current.value.playlist.currentIndex;
      var songDuration = assetsAudioPlayer.current.value.audio.duration;
      var currentPosition = assetsAudioPlayer.currentPosition.value;

      await assetsAudioPlayer.playlistPlayAtIndex(event.indexSong);        
      yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
    }
  }

  Stream<AudioPlayerState> _mapTriggeredPausedAudio(TriggeredPauseAudio event) async* {
    final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
    final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
    final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
    int index = assetsAudioPlayer.current.value.playlist.currentIndex;
    var songDuration = assetsAudioPlayer.current.value.audio.duration;
    var currentPosition = assetsAudioPlayer.currentPosition.value;

    await assetsAudioPlayer.pause();
    yield AudioPlayerPaused(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
  }

  Stream<AudioPlayerState> _mapTriggeredStopAudio(TriggeredStopAudio event) async*{
    try{
      await assetsAudioPlayer.stop();
      yield AudioPlayerInitial();
    }
    catch(_){
      yield AudioPlayerInitial();
    }
  }

  Stream<AudioPlayerState> _mapTriggeredNextAudio(TriggeredNextAudio event) async*{
    await assetsAudioPlayer.next();

    final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
    final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
    final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
    int index = assetsAudioPlayer.current.value.playlist.currentIndex;
    var songDuration = assetsAudioPlayer.current.value.audio.duration;
    var currentPosition = assetsAudioPlayer.currentPosition.value;
    yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
  }

  Stream<AudioPlayerState> _mapTriggeredPrevAudio(TriggeredPrevAudio event) async*{
    await assetsAudioPlayer.previous();

    final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
    final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
    final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
    int index = assetsAudioPlayer.current.value.playlist.currentIndex;
    var songDuration = assetsAudioPlayer.current.value.audio.duration;
    var currentPosition = assetsAudioPlayer.currentPosition.value;
    yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
  }

  Stream<AudioPlayerState> _mapAudioPlayedToState(AudioPlayed event) async* {
    final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
    final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
    final bool isPlaying = assetsAudioPlayer.isPlaying.value;    
    int index = assetsAudioPlayer.current.value.playlist.currentIndex;
    var songDuration = assetsAudioPlayer.current.value.audio.duration;
    var currentPosition = assetsAudioPlayer.currentPosition.value;

    yield AudioPlayerPlaying(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
  }

  Stream<AudioPlayerState> _mapAudioPausedToState( AudioPaused event) async*{
    try{
      final List<Audio> updatedList = assetsAudioPlayer.playlist.audios;
      final Audio currentAudio = assetsAudioPlayer.current.value.audio.audio;
      final bool isPlaying = assetsAudioPlayer.isPlaying.value;
      int index = assetsAudioPlayer.current.value.playlist.currentIndex;
      var songDuration = assetsAudioPlayer.current.value.audio.duration;
      var currentPosition = assetsAudioPlayer.currentPosition.value;
      yield AudioPlayerPaused(index, currentAudio, updatedList ,isPlaying, songDuration, currentPosition);
    }
    catch(_){
      yield AudioPlayerInitial();
    }

  

  }

  Stream<AudioPlayerState> _mapAudioStoppedToState() async* {
    //await assetsAudioPlayer.stop();

    yield AudioPlayerInitial();
    //audioPlayerRepository.updateAllModels(updatedList);
  }
}