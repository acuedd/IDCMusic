/*
import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:church_of_christ/bloc/repository/AudioPlayerRepository.dart';
import 'package:church_of_christ/player/features/AudioPlayerEvent.dart';
import 'package:church_of_christ/player/features/AudioPlayerState.dart';
import 'package:church_of_christ/player/models/AudioPlayerModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {

  final AssetsAudioPlayer assetsAudioPlayer;
  final AudioPlayerRepository audioPlayerRepository;

  List<StreamSubscription> playerSubscriptions = new List();
  
  AudioPlayerBloc({this.assetsAudioPlayer, this.audioPlayerRepository}) : super(AudioPlayerInitial()){
    playerSubscriptions.add(
        assetsAudioPlayer.playerState.listen((event) {
          _mapPlayerStateToEvent(event);
        }));
  }

  @override
  AudioPlayerState get initialState => AudioPlayerInitial();

  @override
  Stream<AudioPlayerState> mapEventToState(AudioPlayerEvent event) async* {
    if(event is InitializeAudio){
      final audioList = await audioPlayerRepository.getAll();
      yield AudioPlayerReady(audioList);
    }

    if(event is AudioPlayed){
      yield* _mapAudioPlayedToState(event);
    }
    if(event is AudioPaused){
      yield* _mapAudioPausedToState(event);
    }
    if(event is AudioStopped){
      yield* _mapAudioStoppedToState();
    }
    if(event is TriggeredPlayAudio){
      yield* _mapTriggeredPlayAudio(event);
    }
    if(event is TriggeredPauseAudio){
      yield* _mapTriggeredPausedAudio(event);
    }
    if(event is AudioCurrent){
      yield* _mapAudioCurrentToState(event);
    }
    if(event is AudioSetCurrent){
      yield* _mapAudioSetCurrentToState(event);
    }
    if(event is AudioSetPlaylist){
      yield* _mapAudioSetPlaylistToState(event);
    }
    if(event is AudioUpdateCurret){
      yield* _mapAudioUpdateCurrent(event);
    }
  }

  @override
  Future<Function> close(){
    playerSubscriptions.forEach((element) {
      element.cancel();
    });
    return assetsAudioPlayer.dispose();
  }

  void _mapPlayerStateToEvent(PlayerState playerState) {
    if(playerState == PlayerState.stop){
      add(AudioStopped());
    }
    else if(playerState == PlayerState.pause){
      add(AudioPaused(assetsAudioPlayer.current.value.audio.audio.metas.id));
    }
    else if(playerState == PlayerState.play){
      add(AudioPlayed(assetsAudioPlayer.current.value.audio.audio.metas.id));
    }
  }

  Stream<AudioPlayerState> _mapAudioPlayedToState(AudioPlayed event) async* {
    final List<AudioPlayerModel> currList = await audioPlayerRepository.getAll();
    //final List<AudioPlayerModel> currList = currentList;
    final List<AudioPlayerModel> updatedList =
    currList
        .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId ? audioModel.copyWithIsPlaying(true) : audioModel.copyWithIsPlaying(false))
        .toList();
    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPlaying = updatedList.firstWhere((model) => model.audio.metas.id == event.audioModelMetaId);
    
    await audioPlayerRepository.updateCurrentSong(currentlyPlaying);
    yield AudioPlayerPlaying(currentlyPlaying, updatedList);
  }

  Stream<AudioPlayerState> _mapAudioPausedToState( AudioPaused event) async*{
    final List<AudioPlayerModel> currentList = await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList =
        currentList
          .map((audioModel) => audioModel.audio.metas.id == event.audioModelMetaId ? audioModel.copyWithIsPlaying(false) : audioModel)
          .toList();
    await audioPlayerRepository.updateAllModels(updatedList);
    final AudioPlayerModel currentlyPaused = currentList.firstWhere((model) => model.audio.metas.id == event.audioModelMetaId);
    
    final AudioPlayerModel currentSong = await audioPlayerRepository.getCurrentSong();
    if(currentSong.audio.metas.id != currentlyPaused.audio.metas.id){    
      yield AudioPlayerPaused(currentSong, updatedList);
    }
    else{
      yield AudioPlayerPaused(currentlyPaused, updatedList);
    }
  }

  Stream<AudioPlayerState> _mapAudioStoppedToState() async* {
    final List<AudioPlayerModel> currentList = await audioPlayerRepository.getAll();
    final List<AudioPlayerModel> updatedList =
    currentList
        .map((audioModel) => audioModel.isPlaying ? audioModel.copyWithIsPlaying(false) : audioModel)
        .toList();

    await assetsAudioPlayer.stop();

    yield AudioPlayerReady(updatedList);
    //audioPlayerRepository.updateAllModels(updatedList);
  }

  Stream<AudioPlayerState> _mapTriggeredPlayAudio(TriggeredPlayAudio event) async* {
    if (state is AudioPlayerReady) {
      final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
      final updatedList = await audioPlayerRepository.updateModel(updatedModel);
      await audioPlayerRepository.updateCurrentSong(updatedModel);

      try{
        await assetsAudioPlayer.open(
          updatedModel.audio,
          showNotification: true
        );
      }
      catch(t){
        print("fuck dont reproduce");
        print(t);
      }
      

      yield AudioPlayerPlaying(updatedModel, updatedList);
    }

    if (state is AudioPlayerPaused) {
      if (event.audioPlayerModel.id == (state as AudioPlayerPaused).pausedEntity.id) {
        final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList = await audioPlayerRepository.updateModel(updatedModel);
        await audioPlayerRepository.updateCurrentSong(updatedModel);

        await assetsAudioPlayer.play();

        yield AudioPlayerPlaying(updatedModel, updatedList);
      }
      else {
        final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
        final updatedList = await audioPlayerRepository.updateModel(updatedModel);
        await audioPlayerRepository.updateCurrentSong(updatedModel);

        await assetsAudioPlayer.open(
            updatedModel.audio,
            showNotification: true,
            respectSilentMode: true,
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug
        );

        yield AudioPlayerPlaying(updatedModel, updatedList);
      }
    }

    if (state is AudioPlayerPlaying) {
      final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(true);
      final updatedList = await audioPlayerRepository.updateModel(updatedModel);
      final playlsit = await audioPlayerRepository.getAll();

      await assetsAudioPlayer.open(
          updatedModel.audio,
          showNotification: true
      );    

      yield AudioPlayerPlaying(updatedModel, updatedList);
    }
  }

  Stream<AudioPlayerState> _mapTriggeredPausedAudio(TriggeredPauseAudio event) async* {
    final AudioPlayerModel updatedModel = event.audioPlayerModel.copyWithIsPlaying(false);
    final updatedList = await audioPlayerRepository.updateModel(updatedModel);
    print("here pause");
    await assetsAudioPlayer.pause();

    yield AudioPlayerPaused(updatedModel, updatedList);
  }

  Stream<AudioPlayerState> _mapAudioCurrentToState(AudioCurrent event) async*{
    final curretSong = await audioPlayerRepository.getCurrentSong();
    final List<AudioPlayerModel> currList = await audioPlayerRepository.getAll();

    yield AudioPlayerPlaying(curretSong, currList);
  }

  Stream<AudioPlayerState> _mapAudioSetPlaylistToState(AudioSetPlaylist event) async*{
    final List<AudioPlayerModel> updatedList = event.listAudioPlayerModel;
    await assetsAudioPlayer.stop();
    await audioPlayerRepository.updateAllModels(updatedList);
    await audioPlayerRepository.updateCurrentSong(event.audioPlayerModel);

    yield AudioPlayerReady(updatedList);
  }

  Stream<AudioPlayerState> _mapAudioSetCurrentToState(AudioSetCurrent event) async*{
    final updatedModel = event.audioPlayerModel;
    await audioPlayerRepository.updateCurrentSong(updatedModel);
    final List<AudioPlayerModel> currList = await audioPlayerRepository.getAll();

    yield AudioPlayerPlaying(updatedModel, currList);
  }

  Stream<AudioPlayerState> _mapAudioUpdateCurrent(AudioUpdateCurret event) async*{
    final updatedModel = event.audioPlayerModel;
    await audioPlayerRepository.updateCurrentSong(updatedModel);
    final List<AudioPlayerModel> currList = await audioPlayerRepository.getAll();

    
    yield AudioPlayerPlaying(updatedModel, currList);
  }

}*/